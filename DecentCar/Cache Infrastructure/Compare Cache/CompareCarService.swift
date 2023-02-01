//
//  CompareCarService.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation

final class CompareCarService {

    private let store: CompareCarStore

    init(store: CompareCarStore) {
        self.store = store
    }
}

extension CompareCarService: CompareCarStore {

    func insert(_ carId: Int64, completion: @escaping (InsertionResult) -> Void) {

        store.insert(carId) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func retrieve(completion: @escaping (RetrievalResult) -> Void) {

        store.retrieve { result in
            switch result {
            case .success(let ids):
                completion(.success(ids))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func delete(where carId: Int64, completion: @escaping (DeletionResult) -> Void) {

        store.delete(where: carId) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
