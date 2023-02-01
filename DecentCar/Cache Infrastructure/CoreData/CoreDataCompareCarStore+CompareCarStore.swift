//
//  CoreDataCompareCarStore+CompareCarStore.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import CoreData

extension CoreDataCompareCarStore: CompareCarStore {

    func insert(_ cardId: Int64, completion: @escaping (InsertionResult) -> Void) {

        perform { context in

            completion(Result {
                let managedSearch = try CompareCar.newUniqueInstance(in: context)
                managedSearch.id = UUID()
                managedSearch.carId = cardId
                managedSearch.createdAt = Date()
                try context.save()
            })
        }
    }

    func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try CompareCar.cars(in: context).map {
                    $0.carId
                }
            })
        }
    }

    func delete(where cardId: Int64, completion: @escaping (DeletionResult) -> Void) {

        perform { context in
            completion(Result {
                try CompareCar.find(where: cardId, in: context).map(context.delete).map(context.save)
            })
        }
    }
}
