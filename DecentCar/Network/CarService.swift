//
//  CarService.swift
//  DecentCar
//
//  Created by Yunus Tek on 29.01.2023.
//

import Foundation

enum NetworkError: Error {

    case connectivity
    case invalidData
}

protocol CarService {

    typealias Result = Swift.Result<CarResponse, Error>

    func getCars(url: URL, completion: @escaping (Result) -> Void)
}

final class RemoteCarService: CarService {

    typealias Result = CarService.Result

    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func getCars(url: URL, completion: @escaping (Result) -> Void) {
        client.getRequest(from: url) { result in
            switch result {
            case .success(let (data, response)):
                completion(RemoteCarService.map(data, from: response))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let response = try CarMapper.map(data, from: response)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
