//
//  HomeLayout.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/30/25.
//

import UIKit

fileprivate struct LocalConstants {
    static let transferListItemSize: CGFloat = 100
    static let sectionSpacing: CGFloat = 16
    static let sectionMargin: CGFloat = 16
    
    static let favItemAndGroupWidth: CGFloat = 100
    static let favItemAndGroupHeight: CGFloat = 80
    
    static let headerHeight: CGFloat = 44
}

struct HomeLayout {
    static func homeListLayoutConfiguration() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(LocalConstants.transferListItemSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = LocalConstants.sectionSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: LocalConstants.sectionMargin,
            leading: LocalConstants.sectionMargin,
            bottom: LocalConstants.sectionMargin,
            trailing: LocalConstants.sectionMargin)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(LocalConstants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .none
        return section
    }
    
    static func homeFavLayoutConfiguration() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LocalConstants.favItemAndGroupWidth),
            heightDimension: .absolute(LocalConstants.favItemAndGroupHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LocalConstants.favItemAndGroupWidth),
            heightDimension: .absolute(LocalConstants.favItemAndGroupHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = LocalConstants.sectionSpacing
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(LocalConstants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]

        section.contentInsets = NSDirectionalEdgeInsets(top: LocalConstants.sectionMargin, leading: LocalConstants.sectionMargin, bottom: LocalConstants.sectionMargin, trailing: LocalConstants.sectionMargin)
        return section
    }
}
