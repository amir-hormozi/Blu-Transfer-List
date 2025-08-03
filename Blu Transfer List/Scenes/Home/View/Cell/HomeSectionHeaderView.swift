//
//  HomeSectionHeaderView.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/3/25.
//

import UIKit

fileprivate struct LocalConstants {
    static let titleLabelFontSize: CGFloat = 22
    static let titleLabelMargin: CGFloat = 8
}

class HomeSectionHeaderView: UICollectionReusableView {
    //MARK: Variable
    static let reuseIdentifier = "SectionHeaderView"
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.titleLabelFontSize, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Function
    private func configure() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: LocalConstants.titleLabelMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LocalConstants.titleLabelMargin)
        ])
    }
}
