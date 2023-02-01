//
//  Operations.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import Foundation

typealias ImageClosure = (_ result: Result<Data, Error>, _ url: URL) -> Void

class Operations {

    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [Data: (imageURL: URL, imageClosure: ImageClosure, operation: ImageDownloadOperation)]()
    private var imageCache = [URL: Data]()

    func addOperation(url: URL, imageService: ImageDataService, imageData: Data, priority: Operation.QueuePriority, completion: @escaping ImageClosure) {

        guard !isOperationExists(with: url) else { return }

        if let cachedData = imageCache[url] {
            completion(.success(cachedData), url)
            return
        }

        if let tupple = dictionaryBlocks.removeValue(forKey: imageData) {
            tupple.operation.cancel()
        }

        let newOperation = ImageDownloadOperation(url: url, imageService: imageService, priority: priority) { [weak self] data, downloadedImageURL in

            guard let self = self,
                  let block = self.dictionaryBlocks[imageData],
                  block.imageURL == downloadedImageURL else { return }

            if let data = data {

                self.imageCache[downloadedImageURL] = data
                block.imageClosure(.success(data), downloadedImageURL)

                if let removedBlock = self.dictionaryBlocks.removeValue(forKey: imageData) {

                    removedBlock.operation.cancel()
                }
            } else {

                block.imageClosure(.failure(NetworkError.invalidData), downloadedImageURL)
            }

            self.dictionaryBlocks.removeValue(forKey: imageData)
        }

        dictionaryBlocks[imageData] = (url, completion, newOperation)
        operationQueue.addOperation(newOperation)
    }

    private func isOperationExists(with url: URL) -> Bool {

        guard let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] else {
            return false
        }

        let opeartions = arrayOperation.filter { $0.url == url }
        
        return opeartions.isEmpty ? false : true
    }
}
