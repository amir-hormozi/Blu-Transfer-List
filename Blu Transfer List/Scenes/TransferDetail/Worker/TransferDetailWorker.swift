//
//  TransferDetailWorker.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation

protocol TransferDetailWorkerProtocol {
    func saveItemToDatabase(fullName: String, transferBusinessModel: HomeModels.HomeListBusinessModel) async -> Bool
    func removeItemFromDatabase(fullName: String) async
    func numberOfItem(fullName: String) -> Int
}

struct TransferDetailWorker { }

//MARK: Worker Extension
extension TransferDetailWorker: TransferDetailWorkerProtocol {
    func saveItemToDatabase(fullName: String, transferBusinessModel: HomeModels.HomeListBusinessModel) async -> Bool {
        let databaseManager = DatabaseManager<TransferFavorite>()
        async let success = databaseManager.saveContext()
        let transfers = databaseManager.createEntity()
        transfers?.fullName = transferBusinessModel.fullName
        transfers?.avatar = transferBusinessModel.avatar
        transfers?.cardNumber = transferBusinessModel.cardNumber
        transfers?.cardType = transferBusinessModel.cardType
        transfers?.email = transferBusinessModel.email
        transfers?.note = transferBusinessModel.note
        return await success
    }
    
    func removeItemFromDatabase(fullName: String) async {
        let databaseManager = DatabaseManager<TransferFavorite>()
        let fetchPredicate = NSPredicate(format: "fullName == %@", fullName)
        let favedItemContext = databaseManager.fetchEntities(predicate: fetchPredicate).first
        guard let favedItemContext = favedItemContext else { return }
        await databaseManager.deleteEntity(favedItemContext)
    }
    
    func numberOfItem(fullName: String) -> Int {
        let fetchPredicate = NSPredicate(format: "fullName == %@", fullName)
        let cdManager = DatabaseManager<TransferFavorite>()
        
        let itemCount = cdManager.fetchEntitiesCount(predicate: fetchPredicate)
        return itemCount
    }
}
