//
//  CarTableViewModel.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation

final class CarTableViewModel {

    var imageService: ImageDataService
    var carOperation: Operations
    var forceUpdateImage: Bool
    var car: Car

    var propertiesString: String = ""
    var description: String = ""
    var price: String = ""
    var imageCount: Int = 0
    var imageUrls: [String?]? = []

    init(imageService: ImageDataService,
         carOperation: Operations,
         forceUpdateImage: Bool,
         car: Car) {

        self.imageService = imageService
        self.carOperation = carOperation
        self.forceUpdateImage = forceUpdateImage
        self.car = car

        configure()
    }

    private func configure() {

        // Properties String
        var mileage = "-"
        if let m = car.mileage {

            mileage = "\(Decimal(m).exactDecimal ?? "-") km"
        }

        let properties = [car.make?.rawValue,
                          car.model?.rawValue,
                          car.modelline?.rawValue,
                          car.fuel?.rawValue,
                          mileage,
                          car.seller?.city?.rawValue,
                          "Seller: \(car.seller?.type?.rawValue ?? "-")"]
            .compactMap { $0 }
            .map { "· \($0)" }

        propertiesString = properties.joined(separator: " ")
        description = car.description ?? ""
        price = Decimal(car.price ?? 0).exactCurrency ?? "-"
        imageCount = car.images?.count ?? 0
        imageUrls = car.images?.map({ $0.url })
    }
}
