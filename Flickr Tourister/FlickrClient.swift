//
//  FlickrClient.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    var session = URLSession.shared
    
    let flickrParams = [FlickrParameterKeys.APIKey: Constants.APIKey, FlickrParameterKeys.Format: FlickrParameterValues.ResponseFormat, "nojsoncallback": "?"] //To receive proper, non funciton enclosed json. source: https://www.flickr.com/services/api/response.json.html
    
    // MARK: Shared Instance
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }

    // MARK: - GET request

    internal func flickrURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? ) -> URL {
        let components = NSURLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }

}
