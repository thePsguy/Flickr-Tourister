//
//  Pin+CoreDataProperties.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 20/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import CoreData

extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var latutude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var imageCount: Int32
    @NSManaged public var lowerBound: Int32
    @NSManaged public var upperBound: Int32
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Pin {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
