//
//  HomeConfigurator.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import UIKit

final class HomeConfigurator {
    @discardableResult
    static func configure() -> HomeViewController {
        let viewController = HomeViewController()
        let worker = HomeWorker()
        let interactor = HomeInteractor(worker: worker)
        let presenter = HomePresenter()
        let router = HomeRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}
