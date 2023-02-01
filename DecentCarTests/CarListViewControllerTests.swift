//
//  CarListViewControllerTests.swift
//  DecentCarTests
//
//  Created by Yunus Tek on 1.02.2023.
//

@testable import DecentCar
import XCTest

final class CarListViewControllerTests: XCTestCase {

    func test_canInit() {

        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.tableView)
    }

    func test_configureCollectionView() {

        let vc = makeVC()
        vc.loadViewIfNeeded()

        XCTAssertNotNil(vc.tableView.delegate, "Expeted TableViewViewDelegate to be not nil")
        XCTAssertNotNil(vc.tableView.dataSource, "Expeted TableViewDataSrouce to be not nil")
    }

    func test_viewDidLoad_initialState() {

        let vc = makeVC()
        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.tableView.numberOfRows(inSection: 0), 0, "Expected number of items is equal to zero")
    }

    func test_displayingTitle() {

        let vc = makeVC()
        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.title, "Decent Car")
    }

    // MARK: - Helpers

    func makeVC(file: StaticString = #filePath, line: UInt = #line) -> CarListViewController {

        let client = URLSessionHTTPClient(session: .shared)
        let remoteService = RemoteCarService(client: client)
        let imageService = RemoteImageDataService(client: client)

        let carOperation = Operations()
        let viewModel = CarListViewModel(
            remoteService: remoteService,
            imageService: imageService,
            carOperation: carOperation)
        let vc = CarListViewController(viewModel: viewModel)
        return vc
    }
}
