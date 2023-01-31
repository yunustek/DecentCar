//
//  CarEndpoint.swift
//  DecentCar
//
//  Created by Yunus Tek on 29.01.2023.
//

import Foundation

enum CarEndpoint {

    case base

    func url(baseURL: URL) -> URL {

        switch self {
        case .base:

            let lastPath = "/"
            var components = URLComponents()

            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + lastPath
            components.queryItems = []
            return components.url!
        }
    }
}
