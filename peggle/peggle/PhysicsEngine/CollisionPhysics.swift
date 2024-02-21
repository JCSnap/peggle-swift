//
//  CollisionPhysics.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

struct CollisionPhysics {
    static func handleCollisionWithImmovableObject
    <T: RoundPhysicsObject, U: RoundPhysicsObject>(movableObject: inout T,
                                                   immovableObject: inout U) {
        if !isColliding(object1: movableObject, object2: immovableObject) {
            return
        }

        applyPositionalCorrection(toObject: &movableObject, asItCollidesWith: &immovableObject)
        let impulse = getImpulse(object1: movableObject, object2: immovableObject)
        movableObject.velocity += impulse
    }

    static func handleCollisionBetween<T: RoundPhysicsObject, U: RoundPhysicsObject>(_ object1: inout T,
                                                                                     and object2: inout U) {
        handleCollisionWithImmovableObject(movableObject: &object1, immovableObject: &object2)
        object2.velocity -= getImpulse(object1: object1, object2: object2)
    }

    static func handleBoundaryCollision<T: RectangularPhysicsObject>(for object: inout T, within bounds: CGRect) {
        reflectVelocityIfNeeded(for: &object, axis: .horizontal, within: bounds)
        reflectVelocityIfNeeded(for: &object, axis: .vertical, within: bounds)
        applyPositionalCorrectionWithBounds(toObject: &object, within: bounds)
    }

    static func isColliding<T: RoundPhysicsObject, U: RoundPhysicsObject>(object1: T, object2: U) -> Bool {
        let distance = (object1.center - object2.center).magnitude
        return distance <= (object1.radius + object2.radius)
    }

    static func isObjectCollidingWithBoundarySide<T: RoundPhysicsObject>(object: T,
                                                                         bounds: CGRect,
                                                                         side: BoundsSide) -> Bool {
        switch side {
        case .left:
            return object.center.x - object.radius <= bounds.minX
        case .right:
            return object.center.x + object.radius >= bounds.maxX
        case .top:
            return object.center.y - object.radius <= bounds.minY
        case .bottom:
            return object.center.y + object.radius >= bounds.maxY
        }
    }
}

// MARK: helpers
extension CollisionPhysics {
    private static func getImpulse<T: RoundPhysicsObject, U: RoundPhysicsObject>(object1: T,
                                                                                 object2: U) -> CGVector {
        let vector = object1.center - object2.center
        let normal = vector.normalized
        let relativeVelocity = object1.velocity - object2.velocity
        let velocityAlongNormal = relativeVelocity.dotProduct(with: normal)

        let restitution = PhysicsEngineConstants.defaultRestitution
        let impulseMagnitude = PhysicsEngineConstants.bounceFactor * -(1 + restitution) * velocityAlongNormal / 2

        return normal * impulseMagnitude
    }
    
    private static func reflectVelocityIfNeeded<T: RectangularPhysicsObject>(for object: inout T,
                                                                       axis: Axis,
                                                                       within bounds: CGRect) {
        switch axis {
        case .horizontal:
            if object.center.x - object.width < bounds.minX || object.center.x + object.width > bounds.maxX {
                object.velocity.dx = -object.velocity.dx
            }
        case .vertical:
            if object.center.y - object.height < bounds.minY || object.center.y + object.height > bounds.maxY {
                object.velocity.dy = -object.velocity.dy
            }
        }
    }

    private static func applyPositionalCorrection
    <T: RoundPhysicsObject, U: RoundPhysicsObject>(toObject object1: inout T,
                                                   asItCollidesWith object2: inout U) {
        let penetrationDepth = (object1.radius + object2.radius) - (object1.center - object2.center).magnitude
        if !isColliding(object1: object1, object2: object2) {
            return // No correction needed if objects are not penetrating
        }
        let correctionVector = (object1.center - object2.center).normalized * penetrationDepth

        object1.center += correctionVector
    }
    
    private static func applyPositionalCorrectionWithBounds<T: RectangularPhysicsObject>(toObject object: inout T,
                                                                                   within bounds: CGRect) {
        applyPositionalCorrectionForHorizontalBounds(object: &object, within: bounds)
        applyPositionalCorrectionForVerticalBounds(object: &object, within: bounds)
    }
    
    private static func applyPositionalCorrectionForHorizontalBounds<T: RectangularPhysicsObject>(object: inout T,
                                                                                            within bounds: CGRect) {
        let leftBound = bounds.minX + object.width
        let rightBound = bounds.maxX - object.width

        if object.center.x < leftBound {
            object.center.x = leftBound
        } else if object.center.x > rightBound {
            object.center.x = rightBound
        }
    }
    
    private static func applyPositionalCorrectionForVerticalBounds<T: RectangularPhysicsObject>(object: inout T,
                                                                                          within bounds: CGRect) {
        let topBound = bounds.minY + object.height
        let bottomBound = bounds.maxY - object.height
        if object.center.y < topBound {
            object.center.y = topBound
        } else if object.center.y > bottomBound {
            object.center.y = bottomBound
        }
    }
}

enum Axis {
    case horizontal, vertical
}

enum BoundsSide {
    case left, right, top, bottom
}

protocol CollisionPhysicsBehaviour {
    mutating func handleBoundaryCollision(within bounds: CGRect)
}
