//
//  FavCell.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

import UIKit

fileprivate struct LocalConstants {
    static let titleSize: CGFloat = 12
    static let identifierSize: CGFloat = 10
    static let itemMargin: CGFloat = 4
    static let cellMargin: CGFloat = 16
    static let iconSize: CGFloat = 20
    static let avatarSize: CGFloat = 25
}

class FavCell: UICollectionViewCell {
    
    //MARK: Variable
    static let reuseIdentifier = "FavCell"

    var item: HomeModels.HomeFavPresentationModel? {
        didSet {
            personNameLabel.text = item?.fullName
            identifierLabel.text = item?.email
            
            guard let image = item?.avatar,
                  let url = URL(string: image) else { return }
            ImageCacher.shared.loadImage(from: url) { image in
                guard let image = image else { return }
                self.avatarImage.image = image
                self.setNeedsLayout()
            }
        }
    }

    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
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
        label.font = UIFont.systemFont(ofSize: LocalConstants.identifierSize, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
        personNameLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    }
    
    //MARK: Function
    private func addView() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(personNameLabel)
        contentView.addSubview(identifierLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImage.widthAnchor.constraint(equalToConstant: LocalConstants.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: LocalConstants.avatarSize),
            
            personNameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: LocalConstants.itemMargin),
            personNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            identifierLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: LocalConstants.itemMargin),
            identifierLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),            
        ])
    }

}
