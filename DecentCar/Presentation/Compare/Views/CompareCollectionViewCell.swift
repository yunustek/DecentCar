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
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var propertiesStackView: UIStackView!

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

        descriptionLabel.text = model.description
        priceLabel.text = model.price

        addProperty(key: "Make", value: model.make)
        addProperty(key: "Model", value: model.model)
        addProperty(key: "Modelline", value: model.modelline)
        addProperty(key: "Millage", value: model.mileage)
        addProperty(key: "Fuel", value: model.fuel)
        addProperty(key: "Color", value: model.color)
        addProperty(key: "Seller", value: model.sellerType)
        addProperty(key: "City", value: model.city)

        let seperatorView = UIView()
        seperatorView.backgroundColor = .clear
        propertiesStackView.addArrangedSubview(seperatorView)

        // Load Car Images
        loadCarImage(urlString: model.imageUrl,
                     imageService: model.imageService,
                     operation: model.carOperation,
                     forceUpdate: model.forceUpdateImage)
    }

    private func addProperty(key: String, value: String) {

        let keyValueStackView = createKeyValueStackView()
        let keyLabel = createKeyLabel()
        keyLabel.text = key
        let valueLabel = createValueLabel()
        valueLabel.text = value

        keyValueStackView.addArrangedSubview(keyLabel)
        keyValueStackView.addArrangedSubview(valueLabel)

        propertiesStackView.addArrangedSubview(keyValueStackView)
        keyValueStackView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
    }

    private func createKeyLabel() -> UILabel {

        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        return label
    }

    private func createValueLabel() -> UILabel {

        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }

    private func createKeyValueStackView() -> UIStackView {

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2

        return stackView
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
