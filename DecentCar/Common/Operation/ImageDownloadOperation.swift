//
//  ImageDownloadOperation.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import Foundation

class ImageDownloadOperation: Operation {

    // MARK: Variables

    let url: URL
    var imageService: ImageDataService
    var customCompletionBlock: ((_ imageData: Data?, _ url: URL) -> Void)?

    // MARK: Initializations

    init(url: URL,
         imageService: ImageDataService,
         completionBlock: @escaping (_ imageData : Data?, _ url: URL) -> Void) {

        self.url = url
        self.imageService = imageService
        self.customCompletionBlock = completionBlock
    }

    override func main() {

        guard !isCancelled else { return }

        imageService.loadImageData(from: url) { result in

                DispatchQueue.main.async { [weak self] in

                    guard let self = self else { return }

                    switch result {
                    case .success(let imageData):

                        guard !self.isCancelled,
                              let completion = self.customCompletionBlock else { return }

                        completion(imageData, self.url)
                    default:
                        guard !self.isCancelled else { return }
                    }
                }
            }
    }
}
