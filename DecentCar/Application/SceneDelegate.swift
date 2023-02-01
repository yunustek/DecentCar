//
//  SceneDelegate.swift
//  DecentCar
//
//  Created by Yunus Tek on 28.01.2023.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }

    func configureWindow() {

        let vc = createRootViewController()
        navigationController.setViewControllers([vc], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func createRootViewController() -> CarListViewController {

        let client = URLSessionHTTPClient(session: .shared)
        let remoteService = RemoteCarService(client: client)
        let imageService = RemoteImageDataService(client: client)

        let carOperation = Operations()
        let viewModel = CarListViewModel(remoteService: remoteService,
                                         imageService: imageService,
                                         carOperation: carOperation)
        
        let vc = CarListViewController(viewModel: viewModel)
        return vc
    }
}
