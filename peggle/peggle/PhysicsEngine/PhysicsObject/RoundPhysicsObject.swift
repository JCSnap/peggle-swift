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
    var isStatic: Bool { get }
}

extension RoundPhysicsObject {
    mutating func handleBoundaryCollision(within bounds: CGRect, applyPositiomalCorrection: Bool = true) {
        self.reflectVelocityIfNeeded(axis: .horizontal, within: bounds)
        self.reflectVelocityIfNeeded(axis: .vertical, within: bounds)
        self.applyPositionalCorrectionWithBounds(within: bounds)
    }
    
    mutating func handleCollision<T: RoundPhysicsObject>(with object: inout T) {
        if !self.isColliding(with: object) || self.isStatic {
            return
        }
        self.applyPositionalCorrection(asItCollidesWith: &object)
        let impulse = self.getImpulse(with: object)
        self.velocity += impulse
        print("new velocity", self.velocity)
        if !object.isStatic {
            object.velocity -= impulse
        }
    }
    
    mutating func handleCollision<T: RectangularPhysicsObject>(with object: inout T) {
        if !self.isColliding(with: object) || self.isStatic {
            return
        }
        self.applyPositionalCorrection(asItCollidesWith: &object)
        let impulse = getImpulse(with: object)
        self.velocity += impulse
        if !object.isStatic {
            object.velocity -= impulse
        }
    }
    
    func isColliding<T: RoundPhysicsObject>(with object: T) -> Bool {
        let distance = (self.center - object.center).magnitude
        return distance <= (self.radius + object.radius)
    }
    
    func isColliding<T: RectangularPhysicsObject>(with object: T) -> Bool {
        let closestPoint = self.getClosestPoint(to: object)
        
        let distanceX = self.center.x - closestPoint.x
        let distanceY = self.center.y - closestPoint.y
        
        return sqrt(distanceX * distanceX + distanceY * distanceY) < self.radius
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
    
    private func getImpulse<T: RoundPhysicsObject>(with object: T) -> CGVector {
        let vector = self.center - object.center
        let normal = vector.normalized
        let relativeVelocity = self.velocity - object.velocity
        let velocityAlongNormal = relativeVelocity.dotProduct(with: normal)

        let restitution = PhysicsEngineConstants.defaultRestitution
        let impulseMagnitude = PhysicsEngineConstants.bounceFactor * -(1 + restitution) * velocityAlongNormal / 2

        return normal * impulseMagnitude
    }
    
    private func getImpulse<T: RectangularPhysicsObject>(with object: T) -> CGVector {
        let closestPoint = getClosestPoint(to: object)
        let impactVector = CGVector(dx: self.center.x - closestPoint.x, dy: self.center.y - closestPoint.y)
        let normal = impactVector.normalized
        
        let relativeVelocity = self.velocity - object.velocity
        
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
    
    private mutating func applyPositionalCorrection<T: RectangularPhysicsObject>(asItCollidesWith object: inout T) {
        if !self.isColliding(with: object) {
            return
        }
        let closestPoint = self.getClosestPoint(to: object)
        let overlapVector = CGVector(dx: self.center.x - closestPoint.x, dy: self.center.y - closestPoint.y)
        let penetrationDepth = self.radius - overlapVector.magnitude
        
        let correctionDirection = overlapVector.normalized
        
        let correctionVector = correctionDirection * penetrationDepth
        
        self.center += correctionVector
    }
    
    private func getClosestPoint<T: RectangularPhysicsObject>(to object: T) -> CGPoint {
        return CGPoint(
            x: max(object.center.x - object.width / 2, min(self.center.x, object.center.x + object.width / 2)),
            y: max(object.center.y - object.height / 2, min(self.center.y, object.center.y + object.height / 2))
        )
    }
}
