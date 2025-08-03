//
//  DatabaseManager.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import CoreData

class DatabaseManager<T: NSManagedObject> {
    
    //MARK: Variable
    private let context: NSManagedObjectContext
    
    //MARK: LifeCycle
    init() {
        self.context = CDContainer.persistentContainer.viewContext
    }
    
    //MARK: Function
    func createEntity() -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as? T
    }
    
    func saveContext() async -> Bool {
       await context.perform { [weak self] in
            do {
                try  self?.context.save()
                return true
            } catch {
            #if DEBUG
                print("Error saving context: \(error.localizedDescription)")
            #endif

                return false
            }
        }
    }
        
    func fetchEntities(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            #if DEBUG
                print("Error fetching entities: \(error.localizedDescription)")
            #endif

            return []
        }
    }
    
    func fetchEntitiesCount(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Int {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try context.count(for: fetchRequest)
        } catch {
            #if DEBUG
                print("Error fetching entities: \(error.localizedDescription)")
            #endif

            return 0
        }
    }
    
    func deleteEntity(_ entity: T) async {
        context.delete(entity)
        Task {
            await saveContext()
        }
    }
}
