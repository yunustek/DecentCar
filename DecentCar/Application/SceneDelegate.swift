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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()
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
        let viewModel = CarListViewModel(
            remoteService: remoteService,
            imageService: imageService,
            photoOperation: carOperation)
        let vc = CarListViewController(viewModel: viewModel)
        return vc
    }
}
