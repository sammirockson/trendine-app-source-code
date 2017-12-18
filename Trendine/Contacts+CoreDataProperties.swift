//
//  Contacts+CoreDataProperties.swift
//  
//
//  Created by Rockson on 06/02/2017.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var lastUpdate: NSDate?
    @NSManaged public var newOrOld: Bool
    @NSManaged public var numberOfNotifications: Int32
    @NSManaged public var objectId: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImageData: NSData?
    @NSManaged public var roomId: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var username: String?

}
