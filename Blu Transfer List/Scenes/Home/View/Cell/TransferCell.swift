//
//  TransferCell.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/30/25.
//

import UIKit

fileprivate struct LocalConstants {
    static let titleSize: CGFloat = 16
    static let identifierSize: CGFloat = 14
    static let itemCornerRadius: CGFloat = 14
    static let itemMargin: CGFloat = 8
    static let cellMargin: CGFloat = 16
    static let iconSize: CGFloat = 20
    static let avatarSize: CGFloat = 50
}

class TransferCell: UICollectionViewCell {
    //MARK: Variable
    static let reuseIdentifier = "TransferCellIdentifier"

    var item: HomeModels.HomeListPresentationModel? { didSet {
        personNameLabel.text = item?.title
        identifierLabel.text = item?.description
        favImage.isHidden = !(item?.isFav ?? false)
        
        guard let image = item?.image,
              let url = URL(string: image) else { return }
        ImageCacher.shared.loadImage(from: url) { image in
            guard let image = image else { return }
            self.avatarImage.image = image
            self.setNeedsLayout()
        }
    }}

    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var personNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.titleSize, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var identifierLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.identifierSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "fav")
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "arrowRight")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        addView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
        favImage.image = nil
        identifierLabel.text = ""
        personNameLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    }
    
    //MARK: Function
    private func configureCell() {
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = LocalConstants.itemCornerRadius
    }
    
    private func addView() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(personNameLabel)
        contentView.addSubview(identifierLabel)
        contentView.addSubview(favImage)
        contentView.addSubview(arrowImage)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LocalConstants.cellMargin),
            avatarImage.widthAnchor.constraint(equalToConstant: LocalConstants.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: LocalConstants.avatarSize),
            
            personNameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            personNameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: LocalConstants.itemMargin),
            personNameLabel.trailingAnchor.constraint(equalTo: favImage.leadingAnchor, constant: -LocalConstants.itemMargin),
            
            identifierLabel.bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: LocalConstants.itemMargin),
            identifierLabel.trailingAnchor.constraint(equalTo: favImage.leadingAnchor, constant: -LocalConstants.itemMargin),
            
            arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocalConstants.cellMargin),
            arrowImage.widthAnchor.constraint(equalToConstant: LocalConstants.iconSize),
            arrowImage.heightAnchor.constraint(equalToConstant: LocalConstants.iconSize),
            
            favImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favImage.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -LocalConstants.itemMargin),
            favImage.widthAnchor.constraint(equalToConstant: LocalConstants.iconSize),
            favImage.heightAnchor.constraint(equalToConstant: LocalConstants.iconSize),
        ])
    }
}
