//
//  PicturesViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 23.11.2021.
//

import UIKit

class PicturesViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let cellIdentifier = String(describing: PicturesCollectionViewCell.self)
    private var pictureLinks = [PictureLinkModel]()
    private let picturesManager = PicturesManager(requestSender: RequestSender())
    private let edgeSpace: CGFloat = 8.0
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemPerRow: CGFloat = 3
        let paddingWidth = edgeSpace * (itemPerRow + 1)
        let availableSpace = UIScreen.main.bounds.width - paddingWidth
        let widthPerItem = availableSpace / itemPerRow
        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        layout.minimumInteritemSpacing = edgeSpace
        layout.minimumLineSpacing = edgeSpace
        layout.sectionInset.left = edgeSpace
        layout.sectionInset.right = edgeSpace
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(PicturesCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.backgroundColor = Theme.current.backgroundColor
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    var pictureSelected: ((UIImage) -> Void)?
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.current.backgroundColor
        self.title = "Выберите изображение"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        setupConstraints()
        loadPicturesLinksList()
    }
    
    // MARK: - Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: edgeSpace),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -edgeSpace),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func loadPicturesLinksList() {
        activityIndicator.startAnimating()
        picturesManager.loadPicuresLinks { [weak self] picturesLinks, error in
            if let error = error {
                        self?.presentAlertWithTitle(title: "Ошибка", message: error, options: "ОК") { (_) in
                        }
                        self?.activityIndicator.stopAnimating()
                        return
                        }
            guard let picturesLinksList = picturesLinks else { return }
            self?.pictureLinks = picturesLinksList
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PicturesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PicturesCollectionViewCell
            else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PicturesCollectionViewCell
        pictureSelected?(cell?.imageView.image ?? UIImage())
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let pictureCell = cell as? PicturesCollectionViewCell,
            let pictureUrl = URL(string: pictureLinks[indexPath.row].url) else { return }
        picturesManager.loadPicture(from: pictureUrl) { (picture, error) in
            guard error == nil,
                let image = picture else { return }
            DispatchQueue.main.async {
                pictureCell.imageView.image = image
            }
        }
    }
    
}
