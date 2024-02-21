//
//  PhysicsObject.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

protocol RoundPhysicsObject: PhysicsObject & CollisionPhysicsBehaviour {
    var center: CGPoint { get set }
    var velocity: CGVector { get set }
    var radius: CGFloat { get }
    var mass: CGFloat { get }
}

extension RoundPhysicsObject {
    mutating func handleBoundaryCollision(within bounds: CGRect) {
        self.reflectVelocityIfNeeded(axis: .horizontal, within: bounds)
        self.reflectVelocityIfNeeded(axis: .vertical, within: bounds)
        self.applyPositionalCorrectionWithBounds(within: bounds)
    }
    
    private mutating func reflectVelocityIfNeeded(axis: Axis, within bounds: CGRect) {
        switch axis {
        case .horizontal:
            if self.center.x - self.radius < bounds.minX || self.center.x + self.radius > bounds.maxX {
                self.velocity.dx = -self.velocity.dx
            }
        case .vertical:
            if self.center.y - self.radius < bounds.minY || self.center.y + self.radius > bounds.maxY {
                self.velocity.dy = -self.velocity.dy
            }
        }
    }
    
    private mutating func applyPositionalCorrectionWithBounds(within bounds: CGRect) {
        self.applyPositionalCorrectionForHorizontalBounds(within: bounds)
        self.applyPositionalCorrectionForVerticalBounds(within: bounds)
    }
    
    private mutating func applyPositionalCorrectionForHorizontalBounds(within bounds: CGRect) {
        let leftBound = bounds.minX + self.radius
        let rightBound = bounds.maxX - self.radius

        if self.center.x < leftBound {
            self.center.x = leftBound
        } else if self.center.x > rightBound {
            self.center.x = rightBound
        }
    }

    private mutating func applyPositionalCorrectionForVerticalBounds(within bounds: CGRect) {
        let topBound = bounds.minY + self.radius
        let bottomBound = bounds.maxY - self.radius
        if self.center.y < topBound {
            self.center.y = topBound
        } else if self.center.y > bottomBound {
            self.center.y = bottomBound
        }
    }
}
