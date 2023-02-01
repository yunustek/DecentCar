//
//  CarImageConstant.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import UIKit

enum CarImageConstant {

    static let tag = 1010

    enum ImageStatus {

        static let empty: UIImage? = nil
        static let failed: UIImage? = UIImage(systemName: "wifi.slash")
        static let noImage: UIImage? = UIImage(systemName: "car.fill")
        static let loading: UIImage? = UIImage(systemName: "arrow.clockwise")
    }
}
