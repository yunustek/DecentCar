//
//  Car.swift
//  DecentCar
//
//  Created by Yunus Tek on 28.01.2023.
//

import Foundation

typealias CarResponse = [Car]

enum Fuel: String, Decodable {

    case gasoline = "Gasoline"
    case diesel = "Diesel"
}

enum Make: String, Decodable {

    case bmw = "BMW"
    case audi = "Audi"
    case ford = "Ford"
    case porsche = "Porsche"
}

enum Model: String, Decodable {

    case bmw_316i = "316i"
    case audi_a8 = "A8"
    case audi_a7 = "A7"
    case ford_mondeo = "Mondeo"
    case porsche_911 = "911"

    var makeType: Make {

        let make: Make

        switch self {
        case .bmw_316i: make = .bmw
        case .audi_a7, .audi_a8: make = .audi
        case .ford_mondeo: make = .ford
        case .porsche_911: make = .porsche
        }

        return make
    }
}

enum ModelLine: String, Decodable {

    case audi_quattro = "quattro"

    var makeType: Make {

        let make: Make

        switch self {
        case .audi_quattro: make = .audi
        }

        return make
    }
}

enum Color: String, Decodable {

    case brown = "Brown"
    case white = "White"
}

struct Car: Decodable {

    let id: Int?
    let make: Make?
    let model: Model?
    let price: Int?
    let firstRegistration: String?
    let mileage: Int?
    let fuel: Fuel?
    let images: [Image]?
    let description: String?
    let modelline: ModelLine?
    let seller: Seller?
    let colour: Color?
}

extension Car: Equatable {

    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.id == rhs.id &&
        lhs.make == rhs.make &&
        lhs.model == rhs.model &&
        lhs.price == rhs.price &&
        lhs.firstRegistration == rhs.firstRegistration &&
        lhs.mileage == rhs.mileage &&
        lhs.fuel == rhs.fuel &&
        lhs.images == rhs.images &&
        lhs.description == rhs.description &&
        lhs.modelline == rhs.modelline &&
        lhs.seller == rhs.seller &&
        lhs.colour == rhs.colour
    }
}
