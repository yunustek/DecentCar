//
//  CompareCar.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import CoreData

extension CompareCar {

    static func cars(in context: NSManagedObjectContext) throws -> [CompareCar] {

        if let entityName = entity().name {
            let request = NSFetchRequest<CompareCar>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            return try context.fetch(request)
        }

        return []
    }

    static func find(where carId: Int64, in context: NSManagedObjectContext) throws -> CompareCar? {

        if let entityName = entity().name {

            let request = NSFetchRequest<CompareCar>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(CompareCar.carId), carId])
            request.fetchLimit = 1
            return try context.fetch(request).first
        }

        return .none
    }

    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> CompareCar {
        CompareCar(context: context)
    }
}
