//
//  Pin+CoreDataClass.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import CoreData


public class Pin: NSManagedObject {

    convenience init(latitude: Double, longitude: Double, title: String, subtitle: String?, lowerBound: Int, upperBound: Int, imageCount: Int, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: ent, insertInto: context)
            self.latutude = latitude
            self.longitude = longitude
            self.title = title
            self.subtitle = subtitle
            self.lowerBound = Int32(lowerBound)
            self.upperBound = Int32(upperBound)
            self.imageCount = Int32(imageCount)
        }else{
            fatalError("Entity not found")
        }
    }
    
}
