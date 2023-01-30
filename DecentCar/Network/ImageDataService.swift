//
//  ImageDataService.swift
//  DecentCar
//
//  Created by Yunus Tek on 29.01.2023.
//

import Foundation

protocol ImageDataService {

    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}

final class RemoteImageDataService: ImageDataService {

    typealias Result = ImageDataService.Result

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) {

        client.getRequest(from: url) { result in
            switch result {
            case .success(let (data, response)):

                guard response.statusCode == 200,
                      !data.isEmpty else {

                    completion(.failure(NetworkError.invalidData))
                    return
                }

                completion(.success(data))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
}
