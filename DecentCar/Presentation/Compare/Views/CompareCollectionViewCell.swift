//
//  CompareCollectionViewCell.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import UIKit
import SnapKit

final class CompareCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets

    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: Variables

    var viewModel: CompareCollectionViewModel!

    // MARK: Initializations

    override func awakeFromNib() {

        super.awakeFromNib()

        applyStyling()
    }

    override func prepareForReuse() {

        super.prepareForReuse()

    }

    private func applyStyling() {

    }

    func bind(model: CompareCollectionViewModel) {

        self.viewModel = model

        configureLayout()

        descriptionLabel.text = model.description

        // Load Car Images
        loadCarImage(urlString: model.imageUrl,
                     imageService: model.imageService,
                     operation: model.carOperation,
                     forceUpdate: model.forceUpdateImage)
    }

    private func configureLayout() {

    }

    private func loadCarImage(urlString: String?, imageService: ImageDataService, operation: Operations, forceUpdate: Bool) {

        carImageView.image = CarImageConstant.ImageStatus.loading

        guard let urlString = urlString,
              let url = URL(string: urlString) else {

            carImageView.image = CarImageConstant.ImageStatus.noImage
            return
        }

        imageService.loadImageData(from: url) { [weak self] result in

            switch result {
            case .success(let data):

                operation.addOperation(url: url,
                                       imageService: imageService,
                                       imageData: data,
                                       priority: .normal) { [weak self] result, url in

                    DispatchQueue.main.async { [weak self] in

                        switch result {
                        case .success(let imageData):

                            self?.carImageView.image = UIImage(data: imageData)
                        case .failure:

                            self?.carImageView.image = CarImageConstant.ImageStatus.failed
                        }
                    }
                }
            case .failure:

                self?.carImageView.image = CarImageConstant.ImageStatus.failed
            }
        }
    }
}
