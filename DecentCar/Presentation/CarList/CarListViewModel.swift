//
//  CarListViewModel.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import Foundation
import Combine

final class CarListViewModel {

    var remoteService: CarService
    var imageService: ImageDataService
    var photoOperation: Operations

    let title = "Decent Car"
    @Published var cars: CarResponse = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    init(remoteService: CarService,
         imageService: ImageDataService,
         photoOperation: Operations) {

        self.remoteService = remoteService
        self.imageService = imageService
        self.photoOperation = photoOperation

        loadCars()
    }

    func reloadCars() {

        cars = []
        loadCars()
    }

    private func loadCars() {

        isLoading = true

        let url = Configuration.baseURL
        let endpoint = CarEndpoint.base.url(baseURL: url)

        remoteService
            .getCars(url: endpoint) { [weak self] result in

            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case let .success(cars):

                self.cars.append(contentsOf: cars)
            case let .failure(error):
                
                self.error = error.localizedDescription
            }
        }
    }
}
