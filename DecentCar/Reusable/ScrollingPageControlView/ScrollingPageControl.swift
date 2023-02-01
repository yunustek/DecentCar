//
//  ScrollingPageControl.swift
//  DecentCar
//
//  Created by Yunus Tek on 1.02.2023.
//

import UIKit

protocol ScrollingPageControlDelegate: AnyObject {

    func viewForDot(at index: Int) -> UIView?
}

class ScrollingPageControl: UIView {

    // MARK: Variables

    weak var delegate: ScrollingPageControlDelegate? {
        didSet {
            createViews()
        }
    }

    //    The number of dots
    var pages: Int = 0 {
        didSet {
            guard pages != oldValue else { return }
            pages = max(0, pages)
            invalidateIntrinsicContentSize()
            createViews()
        }
    }

    private func createViews() {
        dotViews = (0..<pages).map { index in
            delegate?.viewForDot(at: index) ?? CircularView(frame: CGRect(origin: .zero, size: CGSize(width: dotWidth, height: dotHeight)))
        }
    }

    //    The index of the currently selected page
    var selectedPage: Int = 0 {
        didSet {
            guard selectedPage != oldValue else { return }
            selectedPage = max(0, min (selectedPage, pages - 1))
            updateColors()
            if (0..<centerDots).contains(selectedPage - pageOffset) {
                centerOffset = selectedPage - pageOffset
            } else {
                pageOffset = selectedPage - centerOffset
            }
        }
    }

    //    The maximum number of dots that will show in the control
    var maxDots = 7 {
        didSet {
            maxDots = max(3, maxDots)
            if maxDots % 2 == 0 {
                maxDots += 1
                print("maxDots has to be an odd number")
            }
            invalidateIntrinsicContentSize()
        }
    }

    //    The number of dots that will be centered and full-sized
    var centerDots = 3 {
        didSet {
            centerDots = max(1, centerDots)
            if centerDots > maxDots {
                centerDots = maxDots
                print("centerDots has to be equal or smaller than maxDots")
            }
            if centerDots % 2 == 0 {
                centerDots += 1
                print("centerDots has to be an odd number")
            }
            invalidateIntrinsicContentSize()
        }
    }

    //    The duration, in seconds, of the dot slide animation
    var slideDuration: TimeInterval = 0.15
    private var lastSize = CGSize.zero
    private var centerOffset = 0
    private var pageOffset = 0 {
        didSet {
            UIView.animate(withDuration: slideDuration, delay: 0.15, options: [], animations: self.updatePositions, completion: nil)
        }
    }

    var dotViews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            dotViews.forEach(addSubview)
            updateColors()
            setNeedsLayout()
        }
    }

    //    The color of all the unselected dots
    var dotColor = UIColor.lightGray { didSet { updateColors() } }
    //    The color of the currently selected dot
    var selectedColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) { didSet { updateColors() } }

    var dotWidth: CGFloat = 6 {
        didSet {
            dotWidth = max(1, dotWidth)
            dotViews.forEach { $0.frame = CGRect(origin: .zero, size: CGSize(width: dotWidth, height: dotHeight)) }
            invalidateIntrinsicContentSize()
        }
    }

    var dotHeight: CGFloat = 6 {
        didSet {
            dotHeight = max(1, dotHeight)
            dotViews.forEach { $0.frame = CGRect(origin: .zero, size: CGSize(width: dotWidth, height: dotHeight)) }
            invalidateIntrinsicContentSize()
        }
    }

    // Shrink animation
    var shrinkAnimation: Bool = true

    //    The space between dots
    var spacing: CGFloat = 4 {
        didSet {
            spacing = max(1, spacing)
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: Initializations

    init() {
        super.init(frame: .zero)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        updatePositions()
    }

    private func updateColors() {
        dotViews.enumerated().forEach { page, dot in
            dot.tintColor = page == selectedPage ? selectedColor : dotColor
        }
    }

    func updatePositions() {

        let centerDots = min(self.centerDots, pages)
        let maxDots = min(self.maxDots, pages)
        let sidePages = (maxDots - centerDots) / 2
        let horizontalOffset = CGFloat(-pageOffset + sidePages) * (dotWidth + spacing) + (bounds.width - intrinsicContentSize.width) / 2
        let centerPage = centerDots / 2 + pageOffset

        dotViews.enumerated().forEach { page, dot in

            let center = CGPoint(x: horizontalOffset + bounds.minX + dotWidth / 2 + (dotWidth + spacing) * CGFloat(page),
                                 y: bounds.midY)

            let scale: CGFloat = {

                guard shrinkAnimation else {
                    return 1
                }

                let distance = abs(page - centerPage)
                if distance > (maxDots / 2) { return 0 }
                return [1, 0.66, 0.33, 0.16][max(0, min(3, distance - centerDots / 2))]
            }()

            dot.frame = CGRect(origin: .zero, size: CGSize(width: dotWidth * scale, height: dotHeight * scale))
            dot.center = center
        }
    }

    override var intrinsicContentSize: CGSize {

        let pages = min(maxDots, self.pages)
        let width = CGFloat(pages) * dotWidth + CGFloat(pages - 1) * spacing
        let height = dotHeight
        return CGSize(width: width, height: height)
    }
}
