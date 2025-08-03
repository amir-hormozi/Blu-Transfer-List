 //
//  TransferDetailConfigurator.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/3/25.
//

import UIKit

final class TransferDetailConfigurator {
    @discardableResult
    static func configure(transferBusinessModel: HomeModels.HomeListBusinessModel) -> TransferDetailViewController {
        let viewController = TransferDetailViewController()
        let worker = TransferDetailWorker()
        let interactor = TransferDetailInteractor(worker: worker, transferBusinessModel: transferBusinessModel)
        let presenter = TransferDetailPresenter()
        let router = TransferDetailRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
