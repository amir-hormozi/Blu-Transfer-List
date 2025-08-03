//
//  HomeInteractor.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//


protocol HomeBusinessLogic {
    func fetchTransferData()
    func fetchFavorites()
    func fetchNextPage()
    func searchTransfers(query: String)
}

protocol HomeDataStore {
    func getItem(_ index: Int) -> HomeModels.HomeListBusinessModel?
}

class HomeInteractor {
    
    // MARK: Variable
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerProtocol
    private var page: Int = 1
    private var transferListBusinessModel: [HomeModels.HomeListBusinessModel] = []
    private var favoriteFullNames: Set<String> = []
    private var isSearching = false

    //MARK: LifeCycle
    init(worker: HomeWorkerProtocol) {
        self.worker = worker
    }

    //MARK: Function
    private func convertCodableModelToBusinessModel(codableModel: [TransferListCodableModel]) -> [HomeModels.HomeListBusinessModel] {
        var businessModel: [HomeModels.HomeListBusinessModel] = []
        
        codableModel.forEach { model in
            businessModel.append(HomeModels.HomeListBusinessModel(transferCodableModel: model))
        }
        return businessModel
    }
    
    private func updateIsFavStatus(for list: inout [HomeModels.HomeListBusinessModel]) {
        for index in 0..<list.count {
            if let fullName = list[index].fullName {
                list[index].isFav = self.favoriteFullNames.contains(fullName)
            }
        }
    }
}

//MARK: BusinessLogic Extension
extension HomeInteractor: HomeBusinessLogic {
    func fetchTransferData() {
        Task {
            fetchFavorites()
            page = 1
            self.transferListBusinessModel.removeAll()
            do {
                var businessModel = convertCodableModelToBusinessModel(codableModel: try await worker.fetchTransferList(page))
                self.updateIsFavStatus(for: &businessModel)
                self.transferListBusinessModel = businessModel
                await presenter?.updateTransferListData(model: self.transferListBusinessModel, isFullRefresh: true)
            } catch (let error) {
                await presenter?.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }

    func fetchNextPage() {
        guard !isSearching else { return }
        Task {
            page += 1
            do {
                var newPageBusinessModel = convertCodableModelToBusinessModel(codableModel: try await worker.fetchTransferList(page))
                guard !newPageBusinessModel.isEmpty else { return }
                self.updateIsFavStatus(for: &newPageBusinessModel)
                self.transferListBusinessModel.append(contentsOf: newPageBusinessModel)
                
                await presenter?.updateTransferListData(model: newPageBusinessModel, isFullRefresh: false)
            } catch (let error) {
                await presenter?.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }

    func fetchFavorites() {
        Task {
            let favoriteEntities = await worker.fetchFavorites()
            self.favoriteFullNames = Set(favoriteEntities.compactMap { $0.fullName })
            await presenter?.updateFavoritesData(model: favoriteEntities)
            self.updateIsFavStatus(for: &self.transferListBusinessModel)
            await presenter?.updateTransferListData(model: self.transferListBusinessModel, isFullRefresh: true)
        }
    }

    func searchTransfers(query: String) {
        Task {
            if query.isEmpty {
                self.isSearching = false
                await presenter?.updateTransferListData(model: self.transferListBusinessModel, isFullRefresh: true)
            } else {
                self.isSearching = true
                let filteredList = self.transferListBusinessModel.filter {
                    return $0.fullName?.lowercased().contains(query.lowercased()) ?? false
                }
                await presenter?.updateTransferListData(model: filteredList, isFullRefresh: true)
            }
        }
    }
}
 
//MARK: DataStore Extension
extension HomeInteractor: HomeDataStore {
    func getItem(_ index: Int) -> HomeModels.HomeListBusinessModel? {
        guard index < transferListBusinessModel.count else { return nil }
        return transferListBusinessModel[index]
    }
}
