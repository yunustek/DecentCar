//
//  CarListViewController.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import UIKit
import Combine

final class CarListViewController: UITableViewController, Alertable {

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(openFilterPage))
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

    @objc func openFilterPage() {

    }

    @objc func refresh() {

        viewModel.refreshCars()
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

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let cell = cell as? CarTableViewCell else { return }

        cell.bind(with: viewModel.cars[indexPath.row],
                  imageService: viewModel.imageService,
                  operation: viewModel.photoOperation,
                  forceUpdateImage: false)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let compareAction = UIContextualAction(style: .normal, title: "Compare") { (action, view, completion) in
            // compara action
            completion(true)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [compareAction])
        return swipeActionConfig
    }

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // LongPress Menu
        if #available(iOS 15.0, *) {

            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in

                let compareAction = UIAction(title: "Compare",
                                             subtitle: "Add to the compare list and find the best one for you.",
                                             image: nil,
                                             identifier: nil,
                                             discoverabilityTitle: nil,
                                             state: .off) { [weak self] _ in

                    print("Compare")
                }

                let car = self?.viewModel.cars[indexPath.row]
                let title = "\(car?.description ?? "")"

                return UIMenu(title: title, image: nil, identifier: nil, options: .displayInline, children: [compareAction])
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
