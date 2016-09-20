//
//  FlickrPhoto.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

struct FlickrPhoto{

    
    // MARK: Properties
    
    let id: String?
    let title: String?
    let url: String?
    
    // MARK: Initializers
    
    // construct a FlickrPhoto from a dictionary
    init(dictionary: [String:AnyObject]) {
        let keys = FlickrClient.JSONResponseKeys.self
        
        id = dictionary[keys.ID] as? String
        title = dictionary[keys.Title] as? String
        url = dictionary[keys.MediumURL] as? String
    }
    
    static func photosFromResults(results: [[String:AnyObject]]) -> [FlickrPhoto] {
        
        var FlickrPhotos = [FlickrPhoto]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results {
                FlickrPhotos.append(FlickrPhoto(dictionary: result))
            }
        return FlickrPhotos
    }
    
}
