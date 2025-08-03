//
//  HomeWorkerProtocol.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

protocol HomeWorkerProtocol {
    func fetchTransferList( _ page: Int) async throws -> [TransferListCodableModel]
    func fetchFavorites() async -> [TransferFavorite]
}

struct HomeWorker: HomeWorkerProtocol {
    func fetchTransferList( _ page: Int) async throws -> [TransferListCodableModel] {
        let transferList: [TransferListCodableModel] = try await NetworkManager().performRequest(apiConfig: HomeAPIConfig(page: page))
        return transferList
    }
    
    func fetchFavorites() async -> [TransferFavorite] {
        let databaseManager = DatabaseManager<TransferFavorite>()
        return databaseManager.fetchEntities()
    }
}
