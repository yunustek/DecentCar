//
//  CircularView.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import UIKit

class CircularView: UIView {

    override func tintColorDidChange() {
        self.backgroundColor = tintColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    override var frame: CGRect {
        didSet {
            updateCornerRadius()
        }
    }

    private func updateCornerRadius() {
        isRound = true
    }
}
