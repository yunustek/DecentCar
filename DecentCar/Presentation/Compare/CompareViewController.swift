//
//  CompareViewController.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import UIKit
import Combine

final class CompareViewController: UICollectionViewController, Alertable {

    private var viewModel: CompareViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private let compareReuseIdentifier = "CompareCollectionViewCell"
    private var numberOfColumns: CGFloat = 2

    convenience init(viewModel: CompareViewModel) {

        self.init()
        self.viewModel = viewModel
    }

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    private func setupUI() {

        title = viewModel.title
        setupNavigationController()
        setupCollectionView()
    }

    private func setupNavigationController() {

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }

    private func setupCollectionView() {

        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        let nib = UINib(nibName: compareReuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: compareReuseIdentifier)
    }
}

// MARK: - Binding

extension CompareViewController {

    private func bind() {

        bindCars()
        bindError()
    }

    private func bindError() {

        viewModel.$error.sink { [weak self] error in
            guard let self = self else { return }
            if let error = error {

                self.showConfirm("", bodyMessage: error)
            }
        }.store(in: &cancellables)
    }

    private func bindCars() {

        viewModel.$compareCars.sink { [weak self] photos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
}

// MARK: - UICollectionView Configurations

extension CompareViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.compareCars.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: compareReuseIdentifier, for: indexPath) as! CompareCollectionViewCell

        let viewModel = CompareCollectionViewModel(imageService: viewModel.imageService,
                                                   carOperation: viewModel.carOperation,
                                                   forceUpdateImage: false,
                                                   car: viewModel.compareCars[indexPath.row])
        cell.bind(model: viewModel)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompareViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width / numberOfColumns, height: collectionView.bounds.height / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
