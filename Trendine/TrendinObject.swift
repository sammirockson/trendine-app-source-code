//
//  TrendinObject.swift
//  Trendin
//
//  Created by Rockson on 9/26/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreLocation

class TrendinObject: NSObject {
    
    var objectId: String?
    var createdAt: NSDate?
    
    var videoUrl: NSURL?
    var videoPreviewImageUrl: NSURL?
    var imageUrl: NSURL?
    var placeHolderImage: UIImage?
    
    var statusText: String?
    var captionText: String?
    var videoCaptionText: String?
    var videoDuration: Int?
    
    var user: BmobUser?
    var imageWidth: Int?
    var imageHeight: Int?
    
    
    var numberOfComments: Int?
    var numberOfLikes: Int?
    var likersArray: [String]?
    var userLocation: CLLocation?
    
}
