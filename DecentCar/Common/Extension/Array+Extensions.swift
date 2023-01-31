//
//  ArrayExtensions.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import Foundation

extension Array where Element: Equatable {

    mutating func bringToFront(_ element: Element) {
        move(element, to: 0)
    }

    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex = firstIndex(of: element) {
            move(from: oldIndex, to: newIndex)
        }
    }
}

extension Array {

    mutating func move(from oldIndex: Index, to newIndex: Index) {
        guard oldIndex != newIndex else { return }
        if abs(newIndex - oldIndex) == 1 {
            return swapAt(oldIndex, newIndex)
        }
        insert(remove(at: oldIndex), at: newIndex)
    }

    mutating func bringToFront(from oldIndex: Index) {
        move(from: oldIndex, to: 0)
    }
}
