//
//  TransferFavorite+CoreDataClass.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation
import CoreData

@objc(TransferFavorite)
public class TransferFavorite: NSManagedObject { }

extension TransferFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransferFavorite> {
        return NSFetchRequest<TransferFavorite>(entityName: "TransferFavorite")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var cardNumber: String?
    @NSManaged public var cardType: String?
    @NSManaged public var email: String?
    @NSManaged public var fullName: String?
    @NSManaged public var note: String?
}

extension TransferFavorite : Identifiable {

}
