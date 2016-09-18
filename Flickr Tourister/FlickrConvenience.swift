//
//  FlickrConvenience.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 18/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation


extension FlickrClient {
    
    func picturesForLocation(lat: Double, lon: Double, completion: @escaping (_ error: String?, _ photos: [FlickrPhoto]?) -> Void) {
        var baseParams = self.flickrParams
        baseParams[FlickrParameterKeys.Method] = FlickrParameterValues.SearchMethod
        baseParams[FlickrParameterKeys.Extras] = FlickrParameterValues.MediumURL
        baseParams[FlickrParameterKeys.Lat] = String(lat)
        baseParams[FlickrParameterKeys.Lon] = String(lon)
        
        let requestURL = self.flickrURLFromParameters(parameters: baseParams as [String : AnyObject], withPathExtension: nil)
        print(requestURL)
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion("Network Error", nil)
                return
            }
            
            var parsingError: NSError?
            let parsedResult: AnyObject?
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch let error as NSError {
                parsingError = error
                parsedResult = nil
                print("Parse error - \(parsingError!.localizedDescription)")
                return
            }
            
            if(parsedResult?["error"]! != nil){
                completion("Parse Error: " + (parsedResult?["error"] as! String), nil)
            }else{
                let photoData = (parsedResult![JSONResponseKeys.Photos] as? [String: AnyObject])![JSONResponseKeys.Photo]
                let photos = FlickrPhoto.photosFromResults(results: photoData as! [[String : AnyObject]])
                completion(nil, photos)
            }
        }
        task.resume()

        
    }

}
