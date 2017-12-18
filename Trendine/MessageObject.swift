//
//  MessageObject.swift
//  Trendin
//
//  Created by Rockson on 9/27/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class MessageObject: NSObject {
    
    var createdAt: NSDate?
    var imageHeight: Float?
    var imageMessage: NSData?
    var imageMessageURL: String?
    var imageWidth: Float?
    
    
    var lastUpdate: NSDate?
    var objectId: String?
    var roomId: String?
    var senderId: String?
    
    
    var senderName: String?
    var delivered: Bool?
    var textMessage: String?
    
    var audioURL: NSURL?
    var audioData: NSData?
    var audioDuration: Float?
    
    var nameCardId: String?
    var nameCardProfilemageData: NSData?
    var phoneNumber: String?
    var username: String?
    
    var audioListened: Bool?
    
    var stickerData: NSData?
    var stickerWidth: Float?
    var stickerHeight: Float?
    var stickerId: String?

    
    
}
