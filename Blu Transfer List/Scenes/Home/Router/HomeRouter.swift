//
//  HomeRouter.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

protocol HomeRoutingLogic {
    func navigateToDetail(index: Int)
    func navigateToDetail(for favItem: HomeModels.HomeFavPresentationModel)
}

class HomeRouter {
    
    // MARK: Variable
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
}

//MARK: Routing Logic Extension
extension HomeRouter: HomeRoutingLogic {
    func navigateToDetail(for favItem: HomeModels.HomeFavPresentationModel) {
        let businessModel = HomeModels.HomeListBusinessModel(favPresentationModel: favItem)
        let detailVC = TransferDetailConfigurator.configure(transferBusinessModel: businessModel)
        self.viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func navigateToDetail(index: Int) {
        guard let selectedItem = dataStore?.getItem(index) else { return }
        let detailVC = TransferDetailConfigurator.configure(transferBusinessModel: selectedItem)
        self.viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
