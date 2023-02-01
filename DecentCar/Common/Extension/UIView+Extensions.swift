//
//  UIView+Extensions.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import UIKit

extension UIView {

    var cornerRadius: CGFloat {
        set {
            layoutIfNeeded()
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

    var isRound: Bool {
        set {
            cornerRadius = newValue ? min(bounds.width, bounds.height) / 2 : 0
        }
        get {
            return cornerRadius == min(bounds.width, bounds.height) / 2
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {

        cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}
