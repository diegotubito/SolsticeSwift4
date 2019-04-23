//
//  Services.swift
//  Solstice
//
//  Created by iMac on 11/04/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import Foundation

class ServiceManager {
    //variable for storing images in cache, to improve performance and efficiency.
    var imageCache = NSCache<AnyObject, AnyObject>()
    
   
    
}


extension ServiceManager: ServiceManagerProtocol {
    func retrieveData(url: String, result: @escaping(Data?, Error?) -> Void){
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                result(nil, error)
                return
            }
            result(data, nil)
            
        })
        task.resume()
    }
    
    
    func downloadImageFromUrl(url: String, result: @escaping (UIImage?) -> Void, fail: @escaping (Error?) -> Void) {
        //if I have already loaded the image, there's no need to load it again.
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            //return the image previously loaded
            result(imageFromCache)
            return
            
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { (
            data, response, error) -> Void in
            
            guard error == nil else {
                fail(error)
                return
            }
            if data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        //save loaded image to cache for better performance
                        let imageToCache = image
                        self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        result(imageToCache)
                        return
                        
                    }
                    
                }
            }
            result(nil)
            
        }
        dataTask.resume()
        
    }
    
}
