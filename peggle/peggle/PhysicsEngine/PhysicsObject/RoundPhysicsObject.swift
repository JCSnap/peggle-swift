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
    
    mutating func handleCollisionWithImmovableObject<T: RoundPhysicsObject>(object: inout T) {
        if self.isColliding(with: object) {
            return
        }

        self.applyPositionalCorrection(asItCollidesWith: &object)
        let impulse = getImpulse(object1: object, object2: object)
        self.velocity += impulse
    }
    
    func isColliding<T: RoundPhysicsObject>(with object: T) -> Bool {
        let distance = (self.center - object.center).magnitude
        return distance <= (self.radius + object.radius)
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
    
    private func getImpulse<T: RoundPhysicsObject, U: RoundPhysicsObject>(object1: T,
                                                                                 object2: U) -> CGVector {
        let vector = object1.center - object2.center
        let normal = vector.normalized
        let relativeVelocity = object1.velocity - object2.velocity
        let velocityAlongNormal = relativeVelocity.dotProduct(with: normal)

        let restitution = PhysicsEngineConstants.defaultRestitution
        let impulseMagnitude = PhysicsEngineConstants.bounceFactor * -(1 + restitution) * velocityAlongNormal / 2

        return normal * impulseMagnitude
    }

    private mutating func applyPositionalCorrection<T: RoundPhysicsObject>(asItCollidesWith object: inout T) {
        let penetrationDepth = (self.radius + object.radius) - (self.center - object.center).magnitude
        if !self.isColliding(with: object) {
            return // No correction needed if objects are not penetrating
        }
        let correctionVector = (self.center - object.center).normalized * penetrationDepth

        self.center += correctionVector
    }
}
