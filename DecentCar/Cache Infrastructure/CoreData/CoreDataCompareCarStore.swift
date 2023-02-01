//
//  CoreDataCompareCarStore.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import CoreData

final class CoreDataCompareCarStore {

    enum StoreError: Error {

        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    private static let modelName = "DecentCar"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataCompareCarStore.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init(storeURL: URL) throws {

        guard let model = CoreDataCompareCarStore.model else { throw StoreError.modelNotFound }

        do {
            container = try NSPersistentContainer.load(name: CoreDataCompareCarStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        } catch {

            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {

        let context = self.context
        context.perform {
            action(context)
        }
    }

    private func cleanUpReferencesToPersistentStores() {

        context.perform { [weak self] in
            guard let self = self else { return }

            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
