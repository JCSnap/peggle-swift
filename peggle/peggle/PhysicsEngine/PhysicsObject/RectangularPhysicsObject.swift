//
//  RectangularPhysicsObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 21/2/24.
//

import Foundation

protocol RectangularPhysicsObject: PhysicsObject, CollisionPhysicsBehaviour {
    var center: CGPoint { get set }
    var angle: CGFloat { get set }
    var velocity: CGVector { get set }
    var mass: CGFloat { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    var isStatic: Bool { get }
}

extension RectangularPhysicsObject {
    mutating func handleCollision<T: RoundPhysicsObject>(with object: inout T) {
        object.handleCollision(with: &self)
    }

    mutating func handleCollision<T: RectangularPhysicsObject>(with object: inout T) {
        // TODO: implement in future, not needed now
    }

    mutating func handleBoundaryCollision(within bounds: CGRect, applyPositionalCorrection: Bool = true) {
        self.reflectVelocityIfNeeded(axis: .horizontal, within: bounds)
        self.reflectVelocityIfNeeded(axis: .vertical, within: bounds)
        if applyPositionalCorrection {
            self.applyPositionalCorrectionWithBounds(within: bounds)
        }
    }

    func isColliding<T: RoundPhysicsObject>(with object: T) -> Bool {
        object.isColliding(with: self)
    }

    func isColliding<T: RectangularPhysicsObject>(with object: T) -> Bool {
        false
    }

    private mutating func reflectVelocityIfNeeded(axis: Axis, within bounds: CGRect) {
        switch axis {
        case .horizontal:
            if self.center.x - self.width < bounds.minX || self.center.x + self.width > bounds.maxX {
                self.velocity.dx = -self.velocity.dx
            }
        case .vertical:
            if self.center.y - self.height < bounds.minY || self.center.y + self.height > bounds.maxY {
                self.velocity.dy = -self.velocity.dy
            }
        }
    }

    private mutating func applyPositionalCorrectionWithBounds(within bounds: CGRect) {
        self.applyPositionalCorrectionForHorizontalBounds(within: bounds)
        self.applyPositionalCorrectionForVerticalBounds(within: bounds)
    }

    private mutating func applyPositionalCorrectionForHorizontalBounds(within bounds: CGRect) {
        let leftBound = bounds.minX + self.width
        let rightBound = bounds.maxX - self.width

        if self.center.x < leftBound {
            self.center.x = leftBound
        } else if self.center.x > rightBound {
            self.center.x = rightBound
        }
    }

    private mutating func applyPositionalCorrectionForVerticalBounds(within bounds: CGRect) {
        let topBound = bounds.minY + self.height
        let bottomBound = bounds.maxY - self.height
        if self.center.y < topBound {
            self.center.y = topBound
        } else if self.center.y > bottomBound {
            self.center.y = bottomBound
        }
    }
}
