//
//  TransferDetailViewController.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 7/29/25.
//

import UIKit


fileprivate struct LocalConstants {
    static let fullNameFontSize: CGFloat = 16
    static let emailFontSize: CGFloat = 14
    static let noteFontSize: CGFloat = 18
    static let cardTypeFontSize: CGFloat = 14
    
    static let itemMargin: CGFloat = 8
    static let cellMargin: CGFloat = 16
}

protocol TransferDetailDisplayLogic: AnyObject {
    func updateUI(model: TransferDetailModels.TransferDetailPresentationModel)
    func presentErrorMessage(message: String)
    func setFavoriteIcon()
    func setUnfavoriteIcon()
}

class TransferDetailViewController: UIViewController {
    
    // MARK: Variable
    var interactor: TransferDetailBusinessLogic!
    var router: TransferDetailRoutingLogic?

    private lazy var scrollView: UIScrollView = {
       let view = UIScrollView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var transferImage: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 7
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var fullNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.fullNameFontSize, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.emailFontSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var noteLabel: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: LocalConstants.noteFontSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cardTypeLabel: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: LocalConstants.cardTypeFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: LifeCycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureVC()
        addView()
        setupConstraint()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.handleFavoriteStatus()
    }
    
    // MARK: Function
    private func fetchData() {
        interactor.prepareData()
        
    }
    
    private func configureVC() {
        self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    }
    
    private func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(transferImage)
        scrollView.addSubview(fullNameLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(lineView)
        scrollView.addSubview(noteLabel)
        scrollView.addSubview(cardTypeLabel)

    }
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            transferImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: LocalConstants.cellMargin),
            transferImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            transferImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2/4),
            transferImage.heightAnchor.constraint(equalTo: transferImage.widthAnchor),

            fullNameLabel.topAnchor.constraint(equalTo: transferImage.bottomAnchor, constant: LocalConstants.cellMargin),
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LocalConstants.cellMargin),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LocalConstants.cellMargin),

            emailLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: LocalConstants.cellMargin),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LocalConstants.cellMargin),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LocalConstants.cellMargin),

            lineView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: LocalConstants.cellMargin),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LocalConstants.itemMargin),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LocalConstants.itemMargin),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            noteLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: LocalConstants.cellMargin),
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LocalConstants.cellMargin),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LocalConstants.cellMargin),
            noteLabel.bottomAnchor.constraint(equalTo: cardTypeLabel.topAnchor, constant: -LocalConstants.cellMargin),

            cardTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -LocalConstants.cellMargin),
            cardTypeLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: LocalConstants.cellMargin),
        ])
    }
    
    private func setupNavigation() {
        let play = UIBarButtonItem(image: UIImage(named: "love"), style: .plain, target: self, action: #selector(handleFavorite))
        navigationItem.rightBarButtonItems = [play]
    }
    
    @objc private func openWikipedia() {
    }
    
    @objc private func handleFavorite() {
        interactor.changeFavoriteState()
    }
}

//MARK: DisplayLogic Extension
extension TransferDetailViewController: TransferDetailDisplayLogic {
    func updateUI(model: TransferDetailModels.TransferDetailPresentationModel) {
        guard let url = URL(string: model.avatar ?? "") else { return }
        ImageCacher.shared.loadImage(from: url) { image in
            guard let image = image else { return }
            self.transferImage.image = image
        }

        cardTypeLabel.text = model.cardType
        fullNameLabel.text = model.fullName
        emailLabel.text = model.email
        noteLabel.text = model.note
    }
    
    func presentErrorMessage(message: String) {
        showAlert(withTitle: "Error", withMessage: message)
    }
    
    func setFavoriteIcon() {
        navigationItem.rightBarButtonItems?.first?.image = UIImage(systemName: "heart.fill")
    }
    
    func setUnfavoriteIcon() {
        navigationItem.rightBarButtonItems?.first?.image = UIImage(systemName: "heart")
    }
}
