//
//  CarMapper.swift
//  DecentCar
//
//  Created by Yunus Tek on 29.01.2023.
//

import Foundation

final class CarMapper {

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> CarResponse {

        guard response.statusCode == 200,
                let result = try? JSONDecoder().decode(CarResponse.self, from: data) else {
            throw NetworkError.invalidData
        }

        return result
    }
}
