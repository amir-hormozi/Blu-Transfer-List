//
//  CoreDataContainer.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation
import CoreData

class CDContainer {
    private init() {}
   static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransferList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}
