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
        layout.itemSize = .zero
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
        collectionView.register(UINib(nibName: compareReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: compareReuseIdentifier)
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

    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {

        // LongPress Menu
        guard #available(iOS 15.0, *) else { return nil }

        let row = indexPaths.first!.row
        let car = viewModel.compareCars[row]
        let description = car.description ?? ""

        let title = "Remove from compare"

        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in

            let deleteAction = UIAction(title: title,
                                        subtitle: "",
                                        image: nil,
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        state: .mixed) { [weak self] _ in

                self?.showQuestion("Remove from compare", bodyMessage: "Are you sure to Remove from compare?") {

                    self?.viewModel.deleteCar(at: row)
                } no: { }
            }

            return UIMenu(title: description, image: nil, identifier: nil, options: .displayInline, children: [deleteAction])
        }

        return config
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompareViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width / numberOfColumns
        let insets = view.safeAreaInsets
        let height = (collectionView.bounds.height - insets.top - insets.bottom)

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
