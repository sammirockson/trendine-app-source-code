//
//  Messages+CoreDataProperties.swift
//  
//
//  Created by Rockson on 07/02/2017.
//
//

import Foundation
import CoreData


extension Messages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Messages> {
        return NSFetchRequest<Messages>(entityName: "Messages");
    }

    @NSManaged public var audioDuration: Float
    @NSManaged public var audioListened: Bool
    @NSManaged public var audioMessage: NSData?
    @NSManaged public var audioURL: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var imageHeight: Float
    @NSManaged public var imageMessage: NSData?
    @NSManaged public var imageMessageURL: String?
    @NSManaged public var imageWidth: Float
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var nameCardId: String?
    @NSManaged public var nameCardName: String?
    @NSManaged public var nameCardPhoneNumber: String?
    @NSManaged public var nameCardProfileData: NSData?
    @NSManaged public var objectId: String?
    @NSManaged public var roomId: String?
    @NSManaged public var senderId: String?
    @NSManaged public var senderName: String?
    @NSManaged public var sentOrFailed: Bool
    @NSManaged public var stickerData: NSData?
    @NSManaged public var stickerHeight: Float
    @NSManaged public var stickerURL: String?
    @NSManaged public var stickerWidth: Float
    @NSManaged public var textMessage: String?
    @NSManaged public var stickerId: String?

}
