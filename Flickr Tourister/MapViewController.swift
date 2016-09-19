//
//  ViewController.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 16/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController  {

    var pins = [Pin]()
    let flickr = FlickrClient.sharedInstance()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteView: UIView!
    
    // Flag for editing mode
    var editMode = false
    
    // Core Data
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
        //longPress.minimumPressDuration = 1.0
        mapView.delegate = self
        mapView.addGestureRecognizer(longPress)
        addSavedPinsToMap()
    }
    
    func addSavedPinsToMap() {
        
        pins = fetchAllPins()
        print("Pin count in core data is \(pins.count)")
        
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latutude, longitude: pin.longitude)
            annotation.title = pin.title
            annotation.subtitle = pin.subtitle
            mapView.addAnnotation(annotation)
        }
    }
    
    func fetchAllPins() -> [Pin] {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            return try sharedContext.fetch(fetchRequest)
        } catch {
            print("error in fetch")
            return [Pin]()
        }
    }
    
    func dropPin(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
//            var pingImages: [Image]
            annotation.coordinate = coords
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coords.latitude, longitude: coords.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                if let pm = placemarks?[0], let address = pm.addressDictionary!["FormattedAddressLines"] as? NSArray {
                    annotation.subtitle = ""
                    for line in address {
                        if line as! String == address[0] as! String {
                            annotation.title = line as? String
                        }else{
                            annotation.subtitle! += line as! String + " "
                        }
                    }
                    self.mapView.addAnnotation(annotation)
                }
                else {
                    annotation.title = "Unknown Location"
                    self.mapView.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
                
                let corePin = Pin(latitude: coords.latitude, longitude: coords.longitude, title: annotation.title!, subtitle: annotation.subtitle, context: self.sharedContext)
                
                self.flickr.picturesForLocation(lat: coords.latitude, lon: coords.longitude, completion: {error, photos in
                    if error != nil{
                        print(error)
                    }else{
                        var index = 0
                        let count = 5
                        for photo in photos! {
                            if index < count {
                                corePin.addToImages(Image(image: UIImage.init(data: try! Data.init(contentsOf: URL.init(string: photo.url!)!))!, context: self.sharedContext))
//                                print("\(index) downloaded at \(corePin.title)")
                                CoreDataStackManager.sharedInstance().saveContext()
                                index += 1
                            }
                        }
                        
                    }
                })
                self.pins.append(corePin)
            })
        }
    }
    
    @IBAction func editTapped(_ sender: AnyObject) {
        editMode = !editMode
        deleteView.isHidden = !deleteView.isHidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let selectedAnnotation = view.annotation!
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
            for pin in pins{
                if pin.latutude == selectedAnnotation.coordinate.latitude && pin.longitude == selectedAnnotation.coordinate.longitude {
                    if self.editMode {
                        mapView.removeAnnotation(selectedAnnotation)
                        sharedContext.delete(pin)
                        CoreDataStackManager.sharedInstance().saveContext()
                    } else {
                        
//                        print(pin.images!.count, "at \(pin.title) before segue")
                        performSegue(withIdentifier: "pinDetailer", sender: pin)
                    }
                }
            }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views{
            view.canShowCallout = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case "pinDetailer"?:
                let dest = segue.destination as! PhotosViewController
                let pin = sender as! Pin
                dest.selectedPin = pin
        default:
                print("Unknown segue")
        }
    }
}

