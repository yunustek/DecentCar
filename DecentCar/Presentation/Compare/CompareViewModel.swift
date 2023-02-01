//
//  CompareViewModel.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation
import Combine

final class CompareViewModel {

    var service: CompareCarService
    var imageService: ImageDataService
    var carOperation: Operations

    let title = "Compare"

    @Published var error: String? = nil
    @Published var compareCars: [Car] = []

    private var allCars: CarResponse = []

    init(imageService: ImageDataService,
         carOperation: Operations,
         service: CompareCarService,
         cars: CarResponse,
         insertCarId: Int?) {

        self.service = service
        self.imageService = imageService
        self.carOperation = carOperation
        self.allCars = cars

        if let insertCarId = insertCarId {

            insertCar(at: insertCarId)
        } else {

            load()
        }
    }

    func insertCar(at carId: Int) {

        let carId = Int64(carId)

        service
            .insert(carId) { [weak self] result in

                guard let self = self else { return }

                switch result {
                case .success:

                    self.load()
                case .failure(let error):

                    self.error = error.localizedDescription
                }
            }
    }

    private func load() {

        service.retrieve { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let carIds):

                self.compareCars = carIds
                    .compactMap { [weak self] compareId in

                        return self?.allCars.filter({ Int64($0.id ?? -1) == compareId })
                    }
                    .flatMap { $0 }
            case .failure(let error):

                self.error = error.localizedDescription
            }
        }
    }

    func deleteCar(at index: Int) {

        if !compareCars.isEmpty {

            let carId = Int64(compareCars[index].id ?? -1)
            compareCars.remove(at: index)

            service.delete(where: carId) { [weak self] result in

                guard let self = self else { return }
                switch result {
                case .failure(let error):

                    self.error = error.localizedDescription
                default: break
                }
            }
        }
    }
}
