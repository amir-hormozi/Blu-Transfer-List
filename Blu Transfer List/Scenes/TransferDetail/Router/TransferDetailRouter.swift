//
//  TransferDetailRouter.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

protocol TransferDetailRoutingLogic { }

class TransferDetailRouter {
    
    // MARK: Variable
    weak var viewController: TransferDetailViewController?
}

extension TransferDetailRouter: TransferDetailRoutingLogic { }
