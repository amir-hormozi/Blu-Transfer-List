//
//  TransferListCodableModel.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

import Foundation

// MARK: - WelcomeElement
struct TransferListCodableModel: Codable {
    let person: PersonCodableModel?
    let card: CardCodableModel?
    let lastTransfer: Date?
    let note: String?
    let moreInfo: MoreInfoCodableModel?

    enum CodingKeys: String, CodingKey {
        case person
        case card
        case lastTransfer = "last_transfer"
        case note
        case moreInfo = "more_info"
    }
}

// MARK: - Card
struct CardCodableModel: Codable {
    let cardNumber: String?
    let cardType: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

// MARK: - MoreInfo
struct MoreInfoCodableModel: Codable {
    let numberOfTransfers: Int?
    let totalTransfer: Int?

    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}

// MARK: - Person
struct PersonCodableModel: Codable {
    let fullName: String?
    let email: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email
        case avatar
    }
}
