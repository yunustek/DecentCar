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

        imageService.loadImageData(from: url) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let data):

                operation.addOperation(url: url, imageService: imageService, imageData: data) { [weak self] result, url in

                    DispatchQueue.main.async { [weak self] in

                        guard let self = self else { return }

                        switch result {
                        case .success(let imageData):

                            self.carImageView.image = UIImage(data: imageData)
                        case .failure:

                            self.carImageView.image = Constant.CarImageStatus.failed
                        }
                    }
                }
            case .failure:

                self.carImageView.image = Constant.CarImageStatus.failed
            }
        }
    }
}
