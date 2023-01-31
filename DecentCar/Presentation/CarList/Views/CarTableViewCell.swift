//
//  CarTableViewCell.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import UIKit
import SnapKit

final class CarTableViewCell: UITableViewCell {

    private enum Constant {

        enum CarImageStatus {

            static let empty: UIImage? = nil
            static let failed: UIImage? = UIImage(systemName: "wifi.slash")
            static let noImage: UIImage? = UIImage(systemName: "car.fill")
            static let loading: UIImage? = UIImage(systemName: "arrow.clockwise")
        }
    }

    // MARK: Outlets

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var carImageView: UIImageView!

    // MARK: Variables

    private lazy var infoView = UIView()
    private lazy var infoStackView = UIStackView()
    private lazy var descriptionLabel = UILabel()
    private lazy var propertiesLabel = UILabel()

    // MARK: Initializations

    override func awakeFromNib() {

        super.awakeFromNib()

        applyStyling()
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        carImageView.image = Constant.CarImageStatus.empty
    }

    private func applyStyling() {

        carImageView.image = Constant.CarImageStatus.empty
        carImageView.tintColor = .secondarySystemFill
        carImageView.contentMode = .scaleAspectFit

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        propertiesLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        descriptionLabel.numberOfLines = 2
        propertiesLabel.numberOfLines = 1

        infoView.backgroundColor = .black.withAlphaComponent(0.6)

        infoStackView.axis = .vertical
        infoStackView.alignment = .fill
        infoStackView.distribution = .fill
        infoStackView.spacing = 2

        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(propertiesLabel)

        infoView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        containerView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func bind(with car: Car,
              imageService: ImageDataService,
              operation: Operations,
              forceUpdateImage: Bool) {

        let properties = [car.make?.rawValue,
                          car.model?.rawValue,
                          car.modelline?.rawValue,
                          car.fuel?.rawValue,
                          "\(Decimal(car.mileage ?? 0).exactDecimal ?? "0") km"]
            .compactMap { $0 }
            .map { "· \($0)" }

        let propertiesString = properties.joined(separator: " ")
        let description = car.description ?? ""

        descriptionLabel.text = description
        propertiesLabel.text = propertiesString

        // Load Car Image
        loadCarImage(urlString: car.images?.first?.url, imageService: imageService, operation: operation, forceUpdate: forceUpdateImage)
    }

    private func loadCarImage(urlString: String?, imageService: ImageDataService, operation: Operations, forceUpdate: Bool) {

        carImageView.image = Constant.CarImageStatus.loading

        guard let urlString = urlString,
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
