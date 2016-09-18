//
//  Image+CoreDataClass.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class Image: NSManagedObject {

    convenience init(image: UIImage, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Image", in: context){
            self.init( entity: ent, insertInto: context)
            self.image = NSData(data: UIImagePNGRepresentation(image)!)
        }else{
            fatalError("Entity not found.")
        }
    }
}
