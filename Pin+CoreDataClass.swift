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

    convenience init(latitude: Double, longitude: Double, title: String, subtitle: String, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: ent, insertInto: context)
            self.latutude = latitude
            self.longitude = longitude
            self.title = title
            self.subtitle = subtitle
            
        }else{
            fatalError("Entity not found")
        }
    }
    
}
