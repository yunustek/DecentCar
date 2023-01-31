//
//  ImageDownloadManager.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import Nuke
import UIKit

// MARK: Nuke Image

protocol DownloadImage {

    typealias Result = Swift.Result<UIImage, Error>

    /// Download Image with Nuke
    /// - Parameters:
    ///   - imageView: ImageView for image setting
    ///   - url: image URL
    ///   - placeholderImage: Placeholder image will set when start download
    ///   - failureImage: Failure image will set when url is failed
    ///   - priority: Priority for download
    ///   - fadeDuration: fade animation duration for display image
    ///   - fadeInCache: fade animation also for chatched images
    ///   - isPrepareForReuse: For cells
    ///   - forceUpdate: Ignore cache if it's true
    ///   - resulClosure: return success or error
    func downloadImage(imageView: UIImageView,
                       url: URL,
                       placeholderImage: UIImage?,
                       failureImage: UIImage?,
                       priority: ImageRequest.Priority,
                       fadeDuration: TimeInterval,
                       fadeInCache: Bool,
                       isPrepareForReuse: Bool,
                       forceUpdate: Bool,
                       resulClosure: ((Result) -> Void)?)
}

final class ImageDownloadManager: DownloadImage {

    typealias Result = DownloadImage.Result
    typealias CacheItem = (url: URL, size: CGSize)

    private enum ImageDownloadError: Error {

        case invalidUrl
    }

    private enum Constant {

        static let dataCacheKey = "DecentCar_Nuke"
    }

    // MARK: Variables

    static let shared = ImageDownloadManager()
    private var cacheQeueu = [CacheItem]()

    private var pipeline: ImagePipeline {

        return ImagePipeline {

            $0.isTaskCoalescingEnabled = false
            $0.isProgressiveDecodingEnabled = true
            $0.dataLoader = DataLoader(configuration: {
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            $0.imageCache = ImageCache()
            $0.dataCachePolicy = .storeAll
            $0.dataCache = try? DataCache(name: Constant.dataCacheKey)
        }
    }

    func downloadImage(imageView: UIImageView,
                       url: URL,
                       placeholderImage: UIImage? = nil,
                       failureImage: UIImage? = nil,
                       priority: ImageRequest.Priority = .normal,
                       fadeDuration: TimeInterval = 0,
                       fadeInCache: Bool = false,
                       isPrepareForReuse: Bool = false,
                       forceUpdate: Bool = false,
                       resulClosure: ((Result) -> Void)? = nil) {

        DispatchQueue.main.async { [unowned self] in

            let resultImageView = imageView
            resultImageView.contentMode = imageView.contentMode
            resultImageView.frame.size = imageView.frame.size
            resultImageView.tag = 1

            if let image = placeholderImage {
                resultImageView.image = image
            }

            let contentMode = resultImageView.contentMode
            var pixelSize: CGFloat {

                let size = resultImageView.frame.size
                return max(size.height, size.width)
            }
            var resizedImageProcessors: [ImageProcessing] {
                var processors: [ImageProcessing] = []
                if pixelSize != .zero {
                    processors.append(ImageProcessors.Resize(size: CGSize(width: pixelSize, height: pixelSize),
                                                             contentMode: contentMode == .scaleAspectFit ? .aspectFit : .aspectFill))
                }

                return processors
            }

            var requestOptions: ImageRequest.Options = []

            if forceUpdate {
                requestOptions.insert(.reloadIgnoringCachedData)
            }

            let request = ImageRequest(
                url: url,
                processors: resizedImageProcessors,
                priority: priority,
                options: requestOptions
            )

            var loadingOptions = ImageLoadingOptions(
                placeholder: placeholderImage,
                transition: .fadeIn(duration: fadeDuration),
                failureImage: failureImage,
                failureImageTransition: .fadeIn(duration: fadeDuration),
                contentModes: .init(success: contentMode, failure: contentMode, placeholder: contentMode)
            )

            loadingOptions.isPrepareForReuseEnabled = isPrepareForReuse
            loadingOptions.alwaysTransition = fadeInCache
            loadingOptions.pipeline = self.pipeline

            Nuke.loadImage(with: request, options: loadingOptions, into: resultImageView) { (_, _, _) in
                // Progress
            } completion: { result in

                switch result {
                case .success(let response):

                    let image = response.image
                    resultImageView.image = image

                    resulClosure?(.success(response.image))
                case .failure(let error):

                    resultImageView.image = failureImage
                    print("Image Download Error url: \(url.absoluteString)\nerror:", error.localizedDescription)
                    resulClosure?(.failure(error))
                }
            }
        }
    }

    func removeImage(_ urlString: String?) {

        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }

        let request = ImageRequest(url: url)
        pipeline.cache.removeCachedImage(for: request)
    }

    func storeImage(_ image: UIImage?, urlString: String?) {

        guard let urlString = urlString,
              let url = URL(string: urlString),
              let image = image else { return }

        let request = ImageRequest(url: url)
        let imagec = ImageContainer(image: image)

        pipeline.cache.storeCachedImage(imagec, for: request)
    }
}

// MARK: Prefetch

extension ImageDownloadManager {

    func startCacheProcess(with cacheArray: [URL], size: CGSize) {

        var filteredList = cacheArray
        filteredList.removeAll(where: { $0.isFileURL != false })

        let newList = filteredList.map { ($0, size) }

        if !cacheQeueu.isEmpty {
            cacheQeueu.append(contentsOf: newList)
        } else {
            cacheQeueu = newList
        }

        takeNext(removeFirst: false)
    }

    func prioritizeCacheProcess(url: URL) {

        guard let index = cacheQeueu.firstIndex(where: { $0.url == url }) else { return }

        cacheQeueu.bringToFront(from: index)
    }

    // MARK: Private

    private func takeNext(removeFirst: Bool = true) {

        if !cacheQeueu.isEmpty, removeFirst {
            cacheQeueu.removeFirst()
        }

        guard let cacheItem = cacheQeueu.first else {
            // cache completed
            return
        }

        cache(from: cacheItem)
    }

    private func cache(from cache: CacheItem) {

        let cacheImageView = UIImageView(frame: .init(origin: .zero, size: cache.size))

        downloadImage(imageView: cacheImageView, url: cache.url) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success:

                self.takeNext()
            default: break
            }
        }
    }
}
