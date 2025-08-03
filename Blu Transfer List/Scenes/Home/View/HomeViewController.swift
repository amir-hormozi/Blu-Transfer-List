//
//  HomeViewController.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import UIKit

fileprivate struct LocalConstants {
    static let favoriteTitle: String = "Favorites"
    static let listTitle: String = "All"
    static let searchPlaceHolder = "Search Transfers"
}

protocol HomeDisplayLogic: AnyObject {
    func display(items: [HomeModels.TransferItem], for section: HomeModels.sections, isFullRefresh: Bool)
    func presentErrorMessage(title: String, message: String)
}

class HomeViewController: UIViewController {
    typealias DataSorce = UICollectionViewDiffableDataSource<HomeModels.sections, HomeModels.TransferItem>
    typealias SnapShot = NSDiffableDataSourceSnapshot<HomeModels.sections, HomeModels.TransferItem>
    
    // MARK: Variable
    var interactor: HomeBusinessLogic!
    var router: HomeRoutingLogic?
    
    private var homeCollection: UICollectionView!
    private var transferDataSource: DataSorce!
    private var snapShot = SnapShot()
    private var isLoadingMoreData = false

    private let searchController = UISearchController(searchResultsController: nil)
    private var loadingIndicator: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureVC()
        addView()
        setupConstraint()
        fetchTransferData()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchFavorites()
    }
    
    // MARK: Function
    private func fetchTransferList() {
        loadingIndicator.startAnimating()
        interactor.fetchTransferData()
    }
    
    private func configureVC() {
        self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        homeCollection.dataSource = transferDataSource
    }
    
    private func addView() {
        view.addSubview(homeCollection)
        view.addSubview(loadingIndicator)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            homeCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
        
    private func fetchTransferData() {
        loadingIndicator.startAnimating()
        interactor.fetchTransferData()
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalConstants.searchPlaceHolder
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard snapShot.sectionIdentifiers[indexPath.section] == .list, !isLoadingMoreData else { return }
        let listItemsCount = snapShot.numberOfItems(inSection: .list)
        
        if indexPath.item == listItemsCount - 5 {
            isLoadingMoreData = true
            interactor.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = transferDataSource.itemIdentifier(for: indexPath) else { return }
        
        switch selectedItem {
        case .list:
            router?.navigateToDetail(index: indexPath.row)
        case .favorite(let favoriteModel):
            router?.navigateToDetail(for: favoriteModel)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingMoreData, snapShot.indexOfSection(.list) != nil else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            isLoadingMoreData = true
            interactor.fetchNextPage()
        }
    }
}

extension HomeViewController: HomeDisplayLogic {
    func display(items: [HomeModels.TransferItem], for section: HomeModels.sections, isFullRefresh: Bool) {
        loadingIndicator.stopAnimating()
        isLoadingMoreData = false
        
        if snapShot.indexOfSection(section) == nil {
            if section == .list {
                if let favSection = snapShot.sectionIdentifiers.first(where: { $0 == .favorite }) {
                    snapShot.insertSections([.list], afterSection: favSection)
                } else {
                    snapShot.appendSections([.list])
                }
            } else {
                if let firstSection = snapShot.sectionIdentifiers.first {
                    snapShot.insertSections([.favorite], beforeSection: firstSection)
                } else {
                    snapShot.appendSections([.favorite])
                }
            }
        }
        
        if isFullRefresh || section == .favorite {
            let oldItems = snapShot.itemIdentifiers(inSection: section)
            snapShot.deleteItems(oldItems)
        }
        
        if !items.isEmpty {
            snapShot.appendItems(items, toSection: section)
        } else if snapShot.itemIdentifiers(inSection: section).isEmpty {
            snapShot.deleteSections([section])
        }
        
        transferDataSource.apply(snapShot, animatingDifferences: !isFullRefresh)
    }

    func presentErrorMessage(title: String, message: String) {
        isLoadingMoreData = false
        loadingIndicator.stopAnimating()
        showAlert(withTitle: title, withMessage: message)
    }
}

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            guard !self.transferDataSource.snapshot().sectionIdentifiers.isEmpty else { return nil }
            let section = self.transferDataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .favorite:
                return HomeLayout.homeFavLayoutConfiguration()
            case .list:
                return HomeLayout.homeListLayoutConfiguration()
            }
        }
        return layout
    }
    
    private func configureHierarchy() {
        homeCollection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        homeCollection.register(TransferCell.self, forCellWithReuseIdentifier: TransferCell.reuseIdentifier)
        
        homeCollection.register(FavCell.self, forCellWithReuseIdentifier: FavCell.reuseIdentifier)
        homeCollection.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier)
        homeCollection.delegate = self
        homeCollection.backgroundColor = .clear
        homeCollection.showsVerticalScrollIndicator = false
        homeCollection.translatesAutoresizingMaskIntoConstraints = false
        
        transferDataSource = makeTransferListData()
    }
    
    private func makeTransferListData() -> DataSorce {
        let dataSource = DataSorce(collectionView: self.homeCollection) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .favorite(let favItem):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavCell.reuseIdentifier, for: indexPath) as? FavCell else {
                    return UICollectionViewCell()
                }
                cell.item = favItem
                return cell
            case .list(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransferCell.reuseIdentifier, for: indexPath) as? TransferCell else { return UICollectionViewCell() }
                cell.item = item
                return cell

            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self, kind == UICollectionView.elementKindSectionHeader else { return nil }

            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier,
                for: indexPath) as? HomeSectionHeaderView else {
                fatalError("Cannot create new header")
            }
            let section = self.transferDataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .favorite:
                header.title = LocalConstants.favoriteTitle
            case .list:
                header.title = LocalConstants.listTitle
            }

            return header
        }
        return dataSource
    }
}

//MARK: SearchBar Delegates
extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        interactor.searchTransfers(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor.searchTransfers(query: "")
    }
}
