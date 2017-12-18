//
//  Stickers+CoreDataProperties.swift
//  
//
//  Created by Rockson on 12/01/2017.
//
//

import Foundation
import CoreData


extension Stickers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stickers> {
        return NSFetchRequest<Stickers>(entityName: "Stickers");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var previewData: NSData?
    @NSManaged public var stickerData: NSData?
    @NSManaged public var stickerHeight: Float
    @NSManaged public var stickerWidth: Float
    @NSManaged public var stickerId: String?

}
