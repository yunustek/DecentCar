//
//  CompareCollectionViewModel.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation

final class CompareCollectionViewModel {

    private enum Constant {

        static let emptyValueText = "-"
    }

    var imageService: ImageDataService
    var carOperation: Operations
    var forceUpdateImage: Bool
    var car: Car

    var imageUrl: String?
    var description = String()
    var price = String()
    var make = String()
    var model = String()
    var modelline = String()
    var mileage = String()
    var fuel = String()
    var color = String()
    var sellerType = String()
    var city = String()
    var phone = String()

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
        let properties = [car.make?.rawValue,
                          car.model?.rawValue,
                          car.modelline?.rawValue,
                          car.fuel?.rawValue,
                          mileage,
                          car.seller?.city?.rawValue,
                          "Seller: \(car.seller?.type?.rawValue ?? Constant.emptyValueText)"]
            .compactMap { $0 }
            .map { "· \($0)" }

        imageUrl = car.images?.first?.url
        description = car.description ?? ""
        price = Decimal(car.price ?? 0).exactCurrency ?? Constant.emptyValueText
        make = car.make?.rawValue ?? Constant.emptyValueText
        model = car.model?.rawValue ?? Constant.emptyValueText
        modelline = car.modelline?.rawValue ?? Constant.emptyValueText
        mileage = "\(Decimal(car.mileage ?? -1).exactDecimal ?? Constant.emptyValueText) km"
        fuel = car.fuel?.rawValue ?? Constant.emptyValueText
        color = car.colour?.rawValue ?? Constant.emptyValueText
        sellerType = car.seller?.type?.rawValue ?? Constant.emptyValueText
        city = car.seller?.city?.rawValue ?? Constant.emptyValueText
        phone = car.seller?.phone ?? Constant.emptyValueText
    }
}
