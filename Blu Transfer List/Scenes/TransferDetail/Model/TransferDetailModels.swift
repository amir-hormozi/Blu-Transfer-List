//
//  TransferDetailModels.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation

struct TransferDetailModels {    
    struct TransferDetailPresentationModel: Hashable {
        let fullName: String?
        let email: String?
        let avatar: String?
        let cardNumber: String?
        let cardType: String?
        let lastTransfer: Date?
        let note: String?
        let numberOfTransfers: Int?
        let totalTransfer: Int?
        
        init(businessModel: HomeModels.HomeListBusinessModel) {
            self.fullName = businessModel.fullName
            self.email = businessModel.email
            self.avatar = businessModel.avatar
            self.cardNumber = businessModel.cardNumber
            self.cardType = businessModel.cardType
            self.lastTransfer = businessModel.lastTransfer
            self.note = businessModel.note
            self.numberOfTransfers = businessModel.numberOfTransfers
            self.totalTransfer = businessModel.totalTransfer
        }
    }
}
    
