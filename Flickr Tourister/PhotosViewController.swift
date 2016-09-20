//
//  PhotosViewController.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: UIViewController {

    var selectedPin: Pin!
    var latitude: Double!
    var longitude: Double!
    let flickr = FlickrClient.sharedInstance()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    
    var pinImages: [UIImage?] = []
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        initMap()
        refreshCollection()
    }
    
    func refreshCollection(){
        
        pinImages = []
        if selectedPin.images?.count == 0 {
            imagesForPin(exist: false)
        } else {
            imagesForPin(exist: true)
            for item in (selectedPin.images?.allObjects)! {
                let obj = item as! Image
                
                if let img = obj.getImage() {
                    pinImages.append(img)
                } else {
                    pinImages.append(nil)
                }
            }
            collectionView.reloadData()
        }
    }

    @IBAction func getNewCollection(_ sender: AnyObject) {
        let lowerBound = selectedPin.upperBound
        let setSize = FlickrClient.Constants.setSize
        let upperBound = (lowerBound + setSize <= selectedPin.imageCount) ? lowerBound + setSize : selectedPin.imageCount
        flickr.picturesForLocationInBounds(lat: selectedPin.latutude, lon: selectedPin.longitude, lowerIndex: Int(lowerBound), upperIndex: Int(upperBound), completion: {error, photos in
            
            self.selectedPin.removeFromImages(self.selectedPin.images!)
            
            for photo in photos! {
                    self.selectedPin.addToImages(Image(image: UIImage.init(data: try! Data.init(contentsOf: URL.init(string: photo.url!)!))!, context: self.sharedContext))
                    
                    DispatchQueue.main.async {
                        self.imageAdded()
                    }
                    
                    CoreDataStackManager.sharedInstance().saveContext()
                    }
        
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FlickrClient.Constants.setSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosCollectionViewCell
        
        if indexPath.row < pinImages.count  {
            let img = pinImages[pinImages.startIndex.advanced(by: indexPath.row)]
            cell.imageView.image = img
            cell.imageView.isHidden = false
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
        }else{
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
            cell.imageView.isHidden = true
        }
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
        
    }
    
}

extension PhotosViewController: MKMapViewDelegate, MapViewControllerDelegate {
    
    func initMap(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: selectedPin.latutude, longitude: selectedPin.longitude)
        annotation.title = selectedPin.title
        annotation.subtitle = selectedPin.subtitle
        mapView.centerCoordinate = annotation.coordinate
        mapView.addAnnotation(annotation)
    }
    
    func imageAdded() {
        self.refreshCollection()
    }
    
    func imagesForPin(exist: Bool){
        self.collectionView.alpha = exist ? 1.0 : 0.0
        self.infoLabel.isHidden = exist
    }
}
