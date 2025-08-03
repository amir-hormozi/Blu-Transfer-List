//
//  TransferDetailPresenter.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation

protocol TransferDetailPresentationLogic {
    func updateData(model: HomeModels.HomeListBusinessModel)
    @MainActor func presentErrorMessage(message: String)
    @MainActor func setFavoriteIcon(status: Bool)
}

class TransferDetailPresenter {
    
    // MARK: Variable
    weak var viewController: TransferDetailDisplayLogic?
    
    // MARK: Functions
    private func convertBusinessModelToPresentationModel(_ model: HomeModels.HomeListBusinessModel) -> TransferDetailModels.TransferDetailPresentationModel {
        return .init(businessModel: model)
    }
}

//MARK: PresentationLogic Extension
extension TransferDetailPresenter: TransferDetailPresentationLogic {
    func updateData(model: HomeModels.HomeListBusinessModel) {
       let presentaionModel = convertBusinessModelToPresentationModel(model)
        viewController?.updateUI(model: presentaionModel)
    }
    
    func presentErrorMessage(message: String) {
        viewController?.presentErrorMessage(message: message)
    }
        
    func setFavoriteIcon(status: Bool) {
        status ? viewController?.setFavoriteIcon() : viewController?.setUnfavoriteIcon()
    }
}
