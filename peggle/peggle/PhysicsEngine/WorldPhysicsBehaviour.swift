//
//  CollisionPhysics.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

protocol WorldPhysicsBehaviour {
    mutating func applyGravity(deltaTime: TimeInterval, gravity: CGFloat, reverse: Bool)
    mutating func applyFriction(deltaTime: TimeInterval, frictionCoefficient: CGFloat)
    mutating func applyForceInDirection(force: CGFloat, deltaTime: TimeInterval, direction: CGVector)
}

extension WorldPhysicsBehaviour {
    mutating func applyGravity(deltaTime: TimeInterval,
                               gravity: CGFloat = PhysicsEngineConstants.earthGravity,
                               reverse: Bool = false) {
        applyGravity(deltaTime: deltaTime, gravity: gravity, reverse: reverse)
    }
    mutating func applyFriction(deltaTime: TimeInterval,
                                frictionCoefficient: CGFloat =
                                PhysicsEngineConstants.defaultFrictionCoefficient) {
        applyFriction(deltaTime: deltaTime, frictionCoefficient: frictionCoefficient)
    }
}
