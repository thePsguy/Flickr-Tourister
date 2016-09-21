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

    
    var pinImages: [Image] = []
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var newCollectionButton: UIButton!
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
        sharedContext.perform{
            if self.selectedPin.images?.count == 0 {
                self.imagesForPin(exist: false)
            } else {
                self.imagesForPin(exist: true)
                for image in (self.selectedPin.images?.allObjects)! {
                    self.pinImages.append(image as! Image)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    @IBAction func getNewCollection(_ sender: AnyObject) {
        sharedContext.perform {
            self.newCollectionButton.isEnabled = false
            let selectedPin = self.selectedPin!
            let lowerBound = selectedPin.upperBound
            let setSize = FlickrClient.Constants.setSize
            let upperBound = (lowerBound + setSize - 1 <= selectedPin.imageCount) ? (lowerBound + setSize - 1) : selectedPin.imageCount
            selectedPin.lowerBound = lowerBound
            selectedPin.upperBound = upperBound
            
            for image in self.selectedPin.images! {         //Removing previous Images
                self.sharedContext.delete(image as! Image)
            }
            
            DispatchQueue.main.async {
                self.refreshCollection()
            }
            self.flickr.picturesForLocationInBounds(lat: selectedPin.latutude, lon: selectedPin.longitude, lowerIndex: Int(lowerBound), upperIndex: Int(upperBound), completion: {error, photos in
                    for photo in photos! {
                        let img = UIImage.init(data: try! Data.init(contentsOf: URL.init(string: photo.url!)!))!
                        self.sharedContext.perform({
                            self.selectedPin.addToImages(Image(image: img, context: self.sharedContext))
                            DispatchQueue.main.async {
                                self.imageAdded()
                            }
                            CoreDataStackManager.sharedInstance().saveContext()
                        })
                    }
                    DispatchQueue.main.async {
                        self.refreshCollection()
                        self.newCollectionButton.isEnabled = true
                    }
            })
        }
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
            sharedContext.performAndWait({
                cell.imageView.image = self.pinImages[self.pinImages.startIndex.advanced(by: indexPath.row)].getImage()
            })
//            cell.imageView.image = img
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
        self.newCollectionButton.isEnabled = false
//        self.selectedPin.removeFromImages(pinImages[indexPath.row])
        self.sharedContext.performAndWait({
            self.sharedContext.delete(self.pinImages[indexPath.row])
            CoreDataStackManager.sharedInstance().saveContext()
        })
        imageDeleted()
    }
    
}

extension PhotosViewController: MKMapViewDelegate, MapViewControllerDelegate {
    
    func initMap(){
        sharedContext.perform {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.selectedPin.latutude, longitude: self.selectedPin.longitude)
            annotation.title = self.selectedPin.title
            annotation.subtitle = self.selectedPin.subtitle
            DispatchQueue.main.async {
                self.mapView.centerCoordinate = annotation.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func imageAdded() {
        self.refreshCollection()
    }
    
    func loadingComplete() {
        DispatchQueue.main.async {
            self.newCollectionButton.isEnabled = true
        }
    }
    
    func imageDeleted(){
        self.refreshCollection()
        self.sharedContext.perform {
            let selectedPin = self.selectedPin!
            let lowerBound = selectedPin.upperBound
            let setSize = 1
            let upperBound = (lowerBound + setSize <= selectedPin.imageCount) ? lowerBound + setSize : selectedPin.imageCount
            self.selectedPin.lowerBound = lowerBound
            self.selectedPin.upperBound = upperBound
            self.flickr.picturesForLocationInBounds(lat: selectedPin.latutude, lon: selectedPin.longitude, lowerIndex: Int(upperBound), upperIndex: Int(upperBound), completion: {error, photos in
                self.sharedContext.perform ({
                    for photo in photos! {
                        print("got Image")
                        self.selectedPin.addToImages(Image(image: UIImage.init(data: try! Data.init(contentsOf: URL.init(string: photo.url!)!))!, context: self.sharedContext))
                        
                        DispatchQueue.main.async {
                            self.imageAdded()
                        }
                        
                        CoreDataStackManager.sharedInstance().saveContext()
                    }
                    DispatchQueue.main.async {
                        self.newCollectionButton.isEnabled = true
                    }
                })
            })
        }
    }
    
    func imagesForPin(exist: Bool){
        self.collectionView.alpha = exist ? 1.0 : 0.0
        self.infoLabel.isHidden = exist
    }
}
