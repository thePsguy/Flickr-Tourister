//
//  PhotosViewController.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import MapKit

class PhotosViewController: UIViewController {

    var selectedPin: Pin!
    var pinImages: [UIImage?] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCollection()
    }
    
    func refreshCollection(){
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPin.images!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosCollectionViewCell
        
        if let img = pinImages[pinImages.startIndex.advanced(by: indexPath.row)] {
            cell.imageView.image = img
        }else{}
        
        return cell
    }
}

extension PhotosViewController: MKMapViewDelegate {
    
    func initMap(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: selectedPin.latutude, longitude: selectedPin.longitude)
        annotation.title = selectedPin.title
        annotation.subtitle = selectedPin.subtitle
        mapView.centerCoordinate = annotation.coordinate
        mapView.addAnnotation(annotation)
    }

}
