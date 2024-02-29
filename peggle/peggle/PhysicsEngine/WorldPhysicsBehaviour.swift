//
//  CollisionPhysics.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

protocol WorldPhysicsBehaviour {
    mutating func applyGravity(deltaTime: TimeInterval, gravity: CGFloat)
    mutating func applyFriction(deltaTime: TimeInterval, frictionCoefficient: CGFloat)
    
}

extension WorldPhysicsBehaviour {
    mutating func applyGravity(deltaTime: TimeInterval, gravity: CGFloat = PhysicsEngineConstants.earthGravity) {
        applyGravity(deltaTime: deltaTime, gravity: gravity)
    }
    mutating func applyFriction(deltaTime: TimeInterval, frictionCoefficient: CGFloat = PhysicsEngineConstants.defaultFrictionCoefficient) {
        applyFriction(deltaTime: deltaTime, frictionCoefficient: frictionCoefficient)
    }
    
}
