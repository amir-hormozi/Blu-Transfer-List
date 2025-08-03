//
//  HomeModels.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import Foundation

struct HomeModels {
    enum sections: Int, Hashable, CaseIterable {
        case favorite = 0
        case list = 1
    }
    
    enum TransferItem: Hashable {
        case favorite(HomeFavPresentationModel)
        case list(HomeListPresentationModel)
    }
    
    struct HomeListPresentationModel: Hashable {
        var image: String?
        var title: String?
        var description: String?
        var isFav: Bool?
        init(businessModel: HomeListBusinessModel) {
            self.image = businessModel.avatar
            self.title = businessModel.fullName
            self.description = businessModel.email
            self.isFav = businessModel.isFav
        }
        
        static func == (lhs: HomeListPresentationModel, rhs: HomeListPresentationModel) -> Bool {
            return lhs.title == rhs.title
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }
    
    struct HomeFavPresentationModel: Hashable {
        let fullName: String?
        let email: String?
        let avatar: String?
        let cardNumber: String?
        let cardType: String?
        let note: String?

        init(favoriteEntity: TransferFavorite) {
            self.fullName = favoriteEntity.fullName
            self.email = favoriteEntity.email
            self.avatar = favoriteEntity.avatar
            self.cardNumber = favoriteEntity.cardNumber
            self.cardType = favoriteEntity.cardType
            self.note = favoriteEntity.note
        }
    }
    
    struct HomeListBusinessModel {
        let fullName: String?
        let email: String?
        let avatar: String?
        let cardNumber: String?
        let cardType: String?
        let lastTransfer: Date?
        let note: String?
        let numberOfTransfers: Int?
        let totalTransfer: Int?
        var isFav: Bool = false

        init(favPresentationModel: HomeFavPresentationModel) {
            self.fullName = favPresentationModel.fullName
            self.email = favPresentationModel.email
            self.avatar = favPresentationModel.avatar
            self.cardNumber = favPresentationModel.cardNumber
            self.cardType = favPresentationModel.cardType
            self.note = favPresentationModel.note
            self.lastTransfer = nil
            self.numberOfTransfers = nil
            self.totalTransfer = nil
        }

        init(transferCodableModel: TransferListCodableModel) {
            self.fullName = transferCodableModel.person?.fullName
            self.email = transferCodableModel.person?.email
            self.avatar = transferCodableModel.person?.avatar
            self.cardNumber = transferCodableModel.card?.cardNumber
            self.cardType = transferCodableModel.card?.cardType
            self.lastTransfer = transferCodableModel.lastTransfer
            self.note = transferCodableModel.note
            self.numberOfTransfers = transferCodableModel.moreInfo?.numberOfTransfers
            self.totalTransfer = transferCodableModel.moreInfo?.totalTransfer
        }
    }
}
