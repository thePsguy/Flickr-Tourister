//
//  Image+CoreDataProperties.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import CoreData

extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var image: NSData?
    @NSManaged public var pin: Pin?

}
