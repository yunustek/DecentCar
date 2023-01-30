//
//  Seller.swift
//  DecentCar
//
//  Created by Yunus Tek on 28.01.2023.
//

import Foundation

enum SellerType: String, Decodable {

    case `private` = "Private"
    case dealer = "Dealer"
}

enum City: String, Decodable {

    case koln = "Köln"
    case munchen = "München"
    case stuttgart = "Stuttgart"
    case rosenheim = "Rosenheim"
}

struct Seller: Decodable {

    let type: SellerType?
    let phone: String?
    let city: City?
}
