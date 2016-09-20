//
//  FlickrConstants.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation


extension FlickrClient{
    
    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        static let APIKey = "fa09d9190adfbcebb85a952cfd57a1c6"
        static let Secret = "d7eb357bef026863"
        static let BaseUrl = "http://api.flickr.com/services/rest"
        static let setSize = 21
    }
    
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_q"
        static let UseSafeSearch = "1"
    }
    
    // MARK: Flickr Response Keys
    struct JSONResponseKeys {
        static let ID = "id"
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_q"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let Lat = "lat"
        static let Lon = "lon"
        static let Page = "page"
    }

    
}
