//
//  CarTableViewCell.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import UIKit

final class CarTableViewCell: UITableViewCell {

    private enum Constant {

        enum CarImageStatus {

            static let empty: UIImage? = nil
            static let failed: UIImage? = UIImage(systemName: "wifi.slash")
            static let noImage: UIImage? = UIImage(systemName: "car.fill")
            static let loading: UIImage? = UIImage(systemName: "arrow.clockwise")
        }
    }

    @IBOutlet private weak var carImageView: UIImageView!

    override func awakeFromNib() {

        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {

        carImageView.image = Constant.CarImageStatus.empty
        carImageView.tintColor = .secondarySystemFill
        carImageView.contentMode = .scaleAspectFit
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        carImageView.image = Constant.CarImageStatus.empty
    }

    func configure(with car: Car,
                   imageService: ImageDataService,
                   operation: Operations,
                   forceUpdate: Bool) {

        carImageView.image = Constant.CarImageStatus.loading

        guard let image = car.images?.first,
              let urlString = image.url,
              let url = URL(string: urlString) else {

            carImageView.image = Constant.CarImageStatus.noImage
            return
        }

        ImageDownloadManager.shared.downloadImage(imageView: carImageView,
                                                  url: url,
                                                  placeholderImage: Constant.CarImageStatus.loading,
                                                  failureImage: Constant.CarImageStatus.failed,
                                                  priority: .normal,
                                                  fadeDuration: 0.02,
                                                  isPrepareForReuse: true,
                                                  forceUpdate: forceUpdate) { result in
            //
        }
    }
}
