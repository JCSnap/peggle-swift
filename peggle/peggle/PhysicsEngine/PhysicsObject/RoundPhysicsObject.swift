//
//  PhysicsObject.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

protocol RoundPhysicsObject: PhysicsObject & CollisionPhysicsBehaviour {
    var center: CGPoint { get set }
    var angle: CGFloat { get set }
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
    
    mutating func handleCollision<T: PhysicsObject>(with object: inout T) {
        if object is RoundPhysicsObject {
            handleCollision(with: &object)
        } else if object is RectangularPhysicsObject {
            handleCollision(with: &object)
        }
    }
    
    mutating func handleCollision<T: RoundPhysicsObject>(with object: inout T) {
        if !self.isColliding(with: object) || self.isStatic {
            return
        }
        self.applyPositionalCorrection(asItCollidesWith: &object)
        let impulse = self.getImpulse(with: object)
        self.velocity += impulse
        if !object.isStatic {
            object.velocity = (object.velocity - impulse) * (1 / object.mass)
        }
    }
    
    mutating func handleCollision<T: RectangularPhysicsObject>(with object: inout T) {
        guard self.isColliding(with: object) && !self.isStatic else { return }
        
        let closestPoint = self.getClosestPoint(to: object)
        let initialCollisionNormal = calculateInitialCollisionNormal(to: closestPoint)
        let (overlapX, overlapY) = calculateOverlap(with: object)
        
        let (differenceVector, collisionNormal) = determineCorrectionVectorAndNormal(
            overlapX: overlapX,
            overlapY: overlapY,
            initialNormal: initialCollisionNormal,
            objectAngle: object.angle
        )
        
        applyPositionalCorrection(differenceVector)
        applyVelocityCorrection(collisionNormal, with: object)
    }
    
    func isColliding<T: RoundPhysicsObject>(with object: T) -> Bool {
        let distance = (self.center - object.center).magnitude
        return distance <= (self.radius + object.radius)
    }
    
    func isColliding<T: RectangularPhysicsObject>(with object: T) -> Bool {
        let rotatedCenter = getRotatedPoint(point: self.center, around: object.center, by: object.angle)
        return isCollidingWithAxisAlignedRect(center: rotatedCenter, object: object)
    }
    
    func isColliding(with bounds: CGRect) -> Bool {
        return self.center.x - self.radius < bounds.minX || self.center.x + self.radius > bounds.maxX ||
        self.center.y - self.radius < bounds.minY || self.center.y + self.radius > bounds.maxY
    }
}

// MARK: helpers
extension RoundPhysicsObject {
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
    
    private func getRotatedPoint(point: CGPoint, around center: CGPoint, by angle: CGFloat) -> CGPoint {
        let cosAngle = cos(-angle)
        let sinAngle = sin(-angle)
        let translatedX = point.x - center.x
        let translatedY = point.y - center.y
        let rotatedX = translatedX * cosAngle - translatedY * sinAngle
        let rotatedY = translatedX * sinAngle + translatedY * cosAngle
        return CGPoint(x: rotatedX + center.x, y: rotatedY + center.y)
    }

    private func isCollidingWithAxisAlignedRect<T: RectangularPhysicsObject>(center: CGPoint, object: T) -> Bool {
        let closestPoint = getClosestPointToAxisAlignedRect(center: center, object: object)
        let distance = (center - closestPoint).magnitude
        return distance < self.radius
    }

    private func getClosestPointToAxisAlignedRect<T: RectangularPhysicsObject>(center: CGPoint, object: T) -> CGPoint {
        return CGPoint(
            x: max(object.center.x - object.width / 2, min(center.x, object.center.x + object.width / 2)),
            y: max(object.center.y - object.height / 2, min(center.y, object.center.y + object.height / 2))
        )
    }
    
    private func calculateInitialCollisionNormal(to closestPoint: CGPoint) -> CGVector {
        return (self.center - closestPoint).normalized
    }

    private func calculateOverlap<T: RectangularPhysicsObject>(with object: T) -> (CGFloat, CGFloat) {
        let overlapX = self.radius + object.width / 2 - abs(self.center.x - object.center.x)
        let overlapY = self.radius + object.height / 2 - abs(self.center.y - object.center.y)
        return (overlapX, overlapY)
    }

    private func determineCorrectionVectorAndNormal(
        overlapX: CGFloat,
        overlapY: CGFloat,
        initialNormal: CGVector,
        objectAngle: CGFloat
    ) -> (CGVector, CGVector) {
        let isHorizontalCorrection = overlapX < overlapY
        let directionSign: CGFloat = isHorizontalCorrection ? (initialNormal.dx > 0 ? 1 : -1) : (initialNormal.dy > 0 ? 1 : -1)

        var differenceVector: CGVector
        var correctedNormal: CGVector

        if isHorizontalCorrection {
            differenceVector = CGVector(dx: overlapX * directionSign, dy: 0)
            correctedNormal = CGVector(dx: directionSign, dy: 0)
        } else {
            differenceVector = CGVector(dx: 0, dy: overlapY * directionSign)
            correctedNormal = CGVector(dx: 0, dy: directionSign)
        }

        if objectAngle != 0 {
            correctedNormal = rotateVector(correctedNormal, by: objectAngle).normalized
        }

        return (differenceVector, correctedNormal)
    }

    private mutating func applyPositionalCorrection(_ differenceVector: CGVector) {
        self.center += differenceVector
    }

    private mutating func applyVelocityCorrection(_ collisionNormal: CGVector, with object: RectangularPhysicsObject) {
        let velocityAlongNormal = self.velocity.dotProduct(with: collisionNormal)
        let minRestitution = PhysicsEngineConstants.defaultRestitution
        let impulse = collisionNormal * (-velocityAlongNormal * (1 + minRestitution))
        self.velocity += impulse
    }

    private func rotateVector(_ vector: CGVector, by angle: CGFloat) -> CGVector {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        return CGVector(dx: vector.dx * cosAngle - vector.dy * sinAngle, dy: vector.dx * sinAngle + vector.dy * cosAngle)
    }
}
