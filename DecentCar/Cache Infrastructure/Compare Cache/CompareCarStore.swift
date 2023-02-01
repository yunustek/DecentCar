//
//  CompareCarStore.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation

protocol CompareCarStore {

    typealias InsertionResult = Result<Void, Error>
    typealias RetrievalResult = Result<[Int64], Error>
    typealias DeletionResult = Result<Void, Error>

    func insert(_ carId: Int64, completion: @escaping (InsertionResult) -> Void)
    func retrieve(completion: @escaping (RetrievalResult) -> Void)
    func delete(where carId: Int64, completion: @escaping (DeletionResult) -> Void)
}
