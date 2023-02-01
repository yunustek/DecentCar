//
//  CarListViewController.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import UIKit
import Combine
import CallKit

final class CarListViewController: UITableViewController, Alertable {

    private enum Constant {

        static let forceUpdateImage = true
    }

    // MARK: Variables

    private var viewModel: CarListViewModel!
    private var cancellables: Set<AnyCancellable> = []

    private let carReuseIdentifier = "CarTableViewCell"

    // MARK: Initializations

    convenience init(viewModel: CarListViewModel) {

        self.init()
        self.viewModel = viewModel
    }

    init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        applyStyling()
        bind()
    }

    private func applyStyling() {

        title = viewModel.title
        setupNavigationController()
        setupTableView()
    }

    private func setupNavigationController() {

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "eyes.inverse"), style: .plain, target: self, action: #selector(tapToCompareButton))
    }

    private func setupTableView() {

        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            tableView.addSubview(refreshControl)
        }

        // FIXME: Yunus - Create BaseCellDataProtocol protocol
        let nib = UINib(nibName: carReuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: carReuseIdentifier)
        tableView.alwaysBounceVertical = true
        tableView.allowsSelection = false
    }

    @objc func tapToCompareButton() {

        showComparePage()
    }

    @objc func refresh() {

        viewModel.refreshCars()
    }

    private func showComparePage(insertCarId: Int? = nil) {

        let viewModel = CompareViewModel(imageService: self.viewModel.imageService,
                                         carOperation: self.viewModel.carOperation,
                                         service: self.viewModel.compareCarService,
                                         cars: self.viewModel.cars,
                                         insertCarId: insertCarId)
        let vc = CompareViewController(viewModel: viewModel)

        show(vc, sender: self)
    }
}

// MARK: - Binding

extension CarListViewController {

    private func bind() {

        bindLoader()
        bindPhotos()
        bindError()
    }

    private func bindError() {

        viewModel.$error
            .sink { [weak self] error in
                guard let self = self else { return }
                if let error = error {

                    self.showConfirm("", bodyMessage: error)
                }
            }.store(in: &cancellables)
    }

    private func bindPhotos() {

        viewModel.$cars
            .sink { [weak self] _ in

                DispatchQueue.main.async { [weak self] in

                    guard let self = self else { return }

                    self.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }

    private func bindLoader() {

        viewModel.$isLoading
            .sink { [weak self] isLoading in

                DispatchQueue.main.async { [weak self] in

                    guard let self = self else { return }

                    if isLoading {

                        self.refreshControl?.beginRefreshing()
                    } else {

                        self.refreshControl?.endRefreshing()
                    }
                }
            }.store(in: &cancellables)
    }
}

// MARK: - UITableview Configurations

extension CarListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: carReuseIdentifier, for: indexPath) as! CarTableViewCell

        let viewModel = CarTableViewModel(imageService: viewModel.imageService,
                                           carOperation: viewModel.carOperation,
                                           forceUpdateImage: Constant.forceUpdateImage,
                                           car: viewModel.cars[indexPath.row])

        cell.bind(model: viewModel)

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let compareAction = UIContextualAction(style: .normal, title: "Compare") { [weak self] (action, view, completion) in

            guard let self = self else {

                completion(false)
                return
            }

            self.showComparePage(insertCarId: self.viewModel.cars[indexPath.row].id)
            completion(true)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [compareAction])
        return swipeActionConfig
    }

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // LongPress Menu
        if #available(iOS 15.0, *) {

            let car = viewModel.cars[indexPath.row]

            var title: String = "-"
            var subtitle: String = "No Seller Info"

            if let seller = car.seller,
               let phone = seller.phone,
               !phone.isEmpty {

                subtitle = "Call Seller"
                title = phone
            }

            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

                let callSellerAction = UIAction(title: title,
                                             subtitle: subtitle,
                                             image: nil,
                                             identifier: nil,
                                             discoverabilityTitle: nil,
                                             state: .off) { _ in

                    guard let phone = car.seller?.phone,
                          let number = URL(string: "tel://" + phone) else { return }

                    self.showQuestion("Call Seller", bodyMessage: "Are you sure to call seller phone?") {

                        UIApplication.shared.open(number)
                    } no: { }
                }

                let title = "\(car.description ?? "")\nCity: \(car.seller?.city?.rawValue ?? "")"

                return UIMenu(title: title, image: nil, identifier: nil, options: .displayInline, children: [callSellerAction])
            }

            return config
        } else {
            return nil
        }
    }
}

extension CarListViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return tableView.bounds.height / 2.6
    }
}
