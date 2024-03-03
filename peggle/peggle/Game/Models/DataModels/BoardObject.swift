//
//  BoardObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/2/24.
//

import Foundation

class BoardObject: Hashable {
    var center: CGPoint
    var angle: CGFloat
    var size: CGFloat {
        .zero
    }
    var health: CGFloat

    init(center: CGPoint, angle: CGFloat = .zero, health: CGFloat = Constants.defaultHealth) {
        self.center = center
        self.angle = angle
        self.health = health
    }

    func overlaps<T: BoardObject>(with other: T) -> Bool {
        print("Subclasses need to implement this method")
        return false
    }

    func isInBoundary(within size: CGSize) -> Bool {
        print("Subclasses need to implement this method")
        return false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(center)
    }

    static func ==(lhs: BoardObject, rhs: BoardObject) -> Bool {
        lhs.center == rhs.center
    }

    func addToBoard(board: inout Board) {
        board.addObject(self)
    }

    func updateSize(to newSize: CGFloat) {
        print("Subclasses need to implement this method")
    }

    func updateAngle(to newAngle: CGFloat) {
        self.angle = newAngle
    }

    func updateHealth(to newHealth: CGFloat) {
        self.health = newHealth
    }
}
