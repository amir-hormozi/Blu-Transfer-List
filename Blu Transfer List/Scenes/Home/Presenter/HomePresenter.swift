//
//  HomePresenter.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

protocol HomePresentationLogic {
    @MainActor func updateFavoritesData(model: [TransferFavorite])
    @MainActor func updateTransferListData(model: [HomeModels.HomeListBusinessModel], isFullRefresh: Bool)
    @MainActor func presentErrorMessage(message: String)
}

class HomePresenter {
    
    // MARK: Variable
    weak var viewController: HomeDisplayLogic?

    // MARK: Function
    private func convertBusinessModelToPresentationModel(_ model: HomeModels.HomeListBusinessModel) -> HomeModels.TransferItem {
        return .list(HomeModels.HomeListPresentationModel(businessModel: model))
    }
}

//MARK: Presentation Logic Extension
extension HomePresenter: HomePresentationLogic {
    func updateTransferListData(model: [HomeModels.HomeListBusinessModel], isFullRefresh: Bool) {
        let presentationModel: [HomeModels.TransferItem] = model.map(convertBusinessModelToPresentationModel(_:))
        viewController?.display(items: presentationModel, for: .list, isFullRefresh: isFullRefresh)
    }

    func presentErrorMessage(message: String) {
        viewController?.presentErrorMessage(title: "Error", message: message)
    }
    
    func updateFavoritesData(model: [TransferFavorite]) {
        let presentationModels = model.map { HomeModels.HomeFavPresentationModel(favoriteEntity: $0) }
        let favoriteItems = presentationModels.map { HomeModels.TransferItem.favorite($0) }
        viewController?.display(items: favoriteItems, for: .favorite, isFullRefresh: true)
    }
}
