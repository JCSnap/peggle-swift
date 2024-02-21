//
//  WorldPhysics.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

struct WorldPhysics {
    static func applyGravity<T: PhysicsObject>(to object: inout T,
                                               deltaTime: TimeInterval,
                                               gravity: CGFloat = PhysicsEngineConstants.earthGravity) {
        object.velocity.dy -= gravity * CGFloat(deltaTime)
    }

    static func applyFriction<T: RoundPhysicsObject>(to object: inout T,
                                                     deltaTime: TimeInterval,
                                                     frictionCoefficient:
                                                     CGFloat = PhysicsEngineConstants.defaultFrictionCoefficient) {
        // friction is proportional to velocity squared
        let frictionalForceMagnitude = frictionCoefficient * object.velocity.magnitude * object.velocity.magnitude
        let frictionalForceX = frictionalForceMagnitude * (object.velocity.dx / object.velocity.magnitude)
        let frictionalForceY = frictionalForceMagnitude * (object.velocity.dy / object.velocity.magnitude)

        object.velocity.dx -= frictionalForceX * CGFloat(deltaTime)

        object.velocity.dy -= frictionalForceY * CGFloat(deltaTime)
        // velocity will not change direction due to friction
        if object.velocity.dx.sign != frictionalForceX.sign {
            object.velocity.dx = 0
        }

        object.velocity.dy -= frictionalForceY * CGFloat(deltaTime)
        if object.velocity.dy.sign != frictionalForceY.sign {
            object.velocity.dy = 0
        }
    }
    
    static func updateObjectPosition<T: PhysicsObject>(object: inout T, timeInterval: TimeInterval) {
        let newCenter = CGPoint(x: object.center.x + object.velocity.dx * CGFloat(timeInterval),
                                y: object.center.y + object.velocity.dy * CGFloat(timeInterval))
        object.center = newCenter
    }

    static func applyForceInDirectionOfMotion<T: PhysicsObject>(to object: inout T,
                                                                deltaTime: TimeInterval,
                                                                force: CGFloat = .zero) {
        let directionOfMovement = object.velocity.normalized
        object.velocity.dx += directionOfMovement.dx * (force / object.mass) * CGFloat(deltaTime)
        object.velocity.dy += directionOfMovement.dy * (force / object.mass) * CGFloat(deltaTime)
    }

    static func applyForceWithAngle<T: PhysicsObject>(to object: inout T,
                                                      deltaTime: TimeInterval,
                                                      radian: CGFloat,
                                                      force: CGFloat = .zero) {
        let forceX = force * -sin(radian)
        let forceY = force * cos(radian)

        let accelerationX = forceX / object.mass
        let accelerationY = forceY / object.mass

        object.velocity.dx += accelerationX * CGFloat(deltaTime)
        object.velocity.dy += accelerationY * CGFloat(deltaTime)
    }
}
