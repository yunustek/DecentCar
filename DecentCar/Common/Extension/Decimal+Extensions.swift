//
//  Decimal+Extensions.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation

extension Decimal {

    /// Convert to string like "16.450,5", "1.249"
    var exactDecimal: String? {

        if #available(iOS 15.0, *) {

            return formatted()
        } else {

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            return formatter.string(for: self)
        }
    }
}
