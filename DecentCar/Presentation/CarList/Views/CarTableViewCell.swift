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

        static let priceLabelPadding: CGFloat = 4
        static let firstLabelTextColor: UIColor = .white

        enum CarImageStatus {

            static let empty: UIImage? = nil
            static let failed: UIImage? = UIImage(systemName: "wifi.slash")
            static let noImage: UIImage? = UIImage(systemName: "car.fill")
            static let loading: UIImage? = UIImage(systemName: "arrow.clockwise")
        }

        enum Tag {

            static let carImageView = 1010
        }
    }

    // MARK: Outlets

    @IBOutlet private weak var containerView: UIView!

    // MARK: Variables

    private lazy var infoBackgroundView = UIView()
    private lazy var infoStackView = UIStackView()
    private lazy var descriptionLabel = UILabel()
    private lazy var propertiesLabel = UILabel()
    private lazy var priceLabel = PaddingLabel()
    private lazy var itemsStackView = UIStackView()
    private lazy var scrollView = UIScrollView()
    private lazy var pageControlView = UIView()
    private lazy var pageControl = ScrollingPageControl()

    private var carImageView: UIImageView {

        let carImageView = UIImageView()
        carImageView.tintColor = .secondarySystemFill
        carImageView.contentMode = .scaleAspectFit

        return carImageView
    }

    // MARK: Initializations

    override func awakeFromNib() {

        super.awakeFromNib()

        applyStyling()
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        itemsStackView.arrangedSubviews.forEach({
            itemsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
    }

    private func applyStyling() {

        priceLabel.paddingLeft = Constant.priceLabelPadding
        priceLabel.paddingRight = Constant.priceLabelPadding
        priceLabel.paddingTop = Constant.priceLabelPadding
        priceLabel.paddingBottom = Constant.priceLabelPadding

        [descriptionLabel,
         propertiesLabel,
         priceLabel].forEach { $0.textColor = Constant.firstLabelTextColor }

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        propertiesLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        descriptionLabel.numberOfLines = 2
        propertiesLabel.numberOfLines = 1

        infoBackgroundView.backgroundColor = .black.withAlphaComponent(0.6)
        priceLabel.backgroundColor = .black.withAlphaComponent(0.8)

        infoStackView.axis = .vertical
        infoStackView.alignment = .fill
        infoStackView.distribution = .fill
        infoStackView.spacing = 2

        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(propertiesLabel)
    }

    func bind(with car: Car,
              imageService: ImageDataService,
              operation: Operations,
              forceUpdateImage: Bool) {

        var mileage = "-"
        if let m = car.mileage {

            mileage = "\(Decimal(m).exactDecimal ?? "-") km"
        }

        let properties = [car.make?.rawValue,
                          car.model?.rawValue,
                          car.modelline?.rawValue,
                          car.fuel?.rawValue,
                          mileage]
            .compactMap { $0 }
            .map { "· \($0)" }

        let propertiesString = properties.joined(separator: " ")
        let description = car.description ?? ""

        descriptionLabel.text = description
        propertiesLabel.text = propertiesString
        priceLabel.text = Decimal(car.price ?? 0).exactCurrency ?? "-"

        configureScrollView(pageCount: car.images?.count ?? 0)

        configureLayout()

        // Load Car Images
        loadCarImage(urlStrings: car.images?.map({ $0.url }), imageService: imageService, operation: operation, forceUpdate: forceUpdateImage)
    }

    private func configureLayout() {

        scrollView.addSubview(itemsStackView)
        itemsStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(scrollView)
        scrollView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        infoBackgroundView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        containerView.addSubview(infoBackgroundView)
        infoBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        containerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(12)
        }

        containerView.addSubview(pageControlView)
        pageControlView.snp.makeConstraints { make in
            make.bottom.equalTo(infoBackgroundView.snp.top).inset(-14)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
    }

    private func configureScrollView(pageCount: Int) {

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        if pageCount > 1 {

            pageControl.pages = pageCount
            pageControlView.addSubview(pageControl)
            pageControl.snp.remakeConstraints { make in

                if pageCount <= 4 {

                    make.centerX.equalToSuperview().offset(-16)
                } else {
                    make.centerX.equalToSuperview()
                }
            }
        }

        itemsStackView.translatesAutoresizingMaskIntoConstraints = false
        itemsStackView.distribution = .fillEqually
        itemsStackView.axis = .horizontal
        itemsStackView.backgroundColor = .clear
    }

    private func loadCarImage(urlStrings: [String?]?, imageService: ImageDataService, operation: Operations, forceUpdate: Bool) {

        guard let urlStrings = urlStrings else {

            if let carImageView = containerView.subviews.first(where: { $0.tag == Constant.Tag.carImageView }) as? UIImageView {

                carImageView.image = Constant.CarImageStatus.noImage
            } else {

                let carImageView = carImageView
                carImageView.image = Constant.CarImageStatus.noImage
                carImageView.tag = Constant.Tag.carImageView

                containerView.addSubview(carImageView)
                carImageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            return
        }

        urlStrings.forEach { urlString in

            let carImageView = carImageView
            carImageView.image = Constant.CarImageStatus.loading

            itemsStackView.addArrangedSubview(carImageView)
            carImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
            }

            guard let urlString = urlString,
                  let url = URL(string: urlString) else {

                carImageView.image = Constant.CarImageStatus.noImage
                return
            }

            imageService.loadImageData(from: url) { result in

                switch result {
                case .success(let data):

                    operation.addOperation(url: url, imageService: imageService, imageData: data) { result, url in

                        DispatchQueue.main.async {

                            switch result {
                            case .success(let imageData):

                                carImageView.image = UIImage(data: imageData)
                            case .failure:

                                carImageView.image = Constant.CarImageStatus.failed
                            }
                        }
                    }
                case .failure:

                    carImageView.image = Constant.CarImageStatus.failed
                }
            }
        }
    }
}

extension CarTableViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        guard !page.isNaN else { return }

        pageControl.selectedPage = Int(page)
    }
}
