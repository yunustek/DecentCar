//
//  Decimal+Extensions.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import Foundation

extension Decimal {

    /// Convert to string like "16.450,50 €", "1.249,00 €"
    var exactCurrency: String? {

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "de-DE")
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .currency

        return formatter.string(for: self)
    }

    /// Convert to string like "16.450,5", "1.249"
    var exactDecimal: String? {

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "de-DE")
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal

        return formatter.string(for: self)
    }
}
