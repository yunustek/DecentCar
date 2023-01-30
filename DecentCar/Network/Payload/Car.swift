//
//  Car.swift
//  DecentCar
//
//  Created by Yunus Tek on 28.01.2023.
//

import Foundation

typealias CarPayload = [Car]

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
