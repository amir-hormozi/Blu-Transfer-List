//
//  TransferDetailInteractor.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation
import SafariServices

protocol TransferDetailBusinessLogic {
    func prepareData()
    func changeFavoriteState()
    @MainActor func handleFavoriteStatus()
}

class TransferDetailInteractor {
    
    // MARK: Variable
    var presenter: TransferDetailPresentationLogic?
    var worker: TransferDetailWorkerProtocol
    private var transferBusinessModel: HomeModels.HomeListBusinessModel

    // MARK: LifeCycle
    init(worker: TransferDetailWorkerProtocol, transferBusinessModel: HomeModels.HomeListBusinessModel) {
        self.worker = worker
        self.transferBusinessModel = transferBusinessModel
    }
    
    //MARK: Function
    fileprivate func saveItemToDatabase() {
        guard let fullName = transferBusinessModel.fullName else { return }
        Task (priority: .background) {
            let isSucess = await worker.saveItemToDatabase(fullName: fullName, transferBusinessModel: self.transferBusinessModel)
            await self.presenter?.setFavoriteIcon(status: isSucess)
        }
    }
    
    private func removeItemFromDatabase() {
        guard let fullName = transferBusinessModel.fullName else { return }
        Task {
            await worker.removeItemFromDatabase(fullName: fullName)
            await self.presenter?.setFavoriteIcon(status: false)
        }
    }

    fileprivate func checkItemIsFavorite() -> Bool {
        guard let fullName = transferBusinessModel.fullName else { return false }
        let itemCount = worker.numberOfItem(fullName: fullName)
        return itemCount != 0
    }
}

//MARK: BusinessLogic Extension
extension TransferDetailInteractor: TransferDetailBusinessLogic {
    func prepareData() {
        guard let _ = transferBusinessModel.fullName else { return }
        presenter?.updateData(model: transferBusinessModel)
    }
        
    func changeFavoriteState() {
        checkItemIsFavorite() ? removeItemFromDatabase() : saveItemToDatabase()
    }
    
    func handleFavoriteStatus() {
        presenter?.setFavoriteIcon(status: checkItemIsFavorite())
    }
    
}
