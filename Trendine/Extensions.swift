//
//  Extensions.swift
//  gameofchats
//
//  Created by Brian Voong on 7/5/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

//let imageCache = NSCache()
 var imageCache = NSCache<AnyObject, AnyObject>()

class customImageView:  UIImageView {
    
    var imageUrl: String?
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        self.imageUrl = urlString
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    if self.imageUrl == urlString {
                        
                        self.image = downloadedImage
                        
                        
                    }
                }
                
            }
            
            
            
        }).resume()
    }
}







