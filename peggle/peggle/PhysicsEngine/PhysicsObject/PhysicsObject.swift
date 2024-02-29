//
//  PhysicsObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 18/2/24.
//

import Foundation

protocol PhysicsObject: CollisionPhysicsBehaviour, WorldPhysicsBehaviour {
    var center: CGPoint { get set }
    var angle: CGFloat { get set }
    var velocity: CGVector { get set }
    var mass: CGFloat { get }
    var isStatic: Bool { get }
}

extension PhysicsObject {
    mutating func applyGravity(deltaTime: TimeInterval, gravity: CGFloat = PhysicsEngineConstants.earthGravity) {
        if self.isStatic {
            return
        }
        self.velocity.dy -= gravity * CGFloat(deltaTime)
    }
    
    mutating func applyFriction(deltaTime: TimeInterval, frictionCoefficient: CGFloat = PhysicsEngineConstants.defaultFrictionCoefficient) {
        if self.isStatic || self.velocity.magnitude == 0 {
            return
        }
        self.velocity = self.velocity * PhysicsEngineConstants.defaultFrictionCoefficient
    }
    
    mutating func updateObjectPosition(timeInterval: TimeInterval) {
        let newCenter = CGPoint(x: self.center.x + self.velocity.dx * CGFloat(timeInterval),
                                y: self.center.y + self.velocity.dy * CGFloat(timeInterval))
        self.center = newCenter
    }

    mutating func applyForceWithAngle(deltaTime: TimeInterval, radian: CGFloat, force: CGFloat = .zero) {
        let forceX = force * -sin(radian)
        let forceY = force * cos(radian)

        let accelerationX = forceX / self.mass
        let accelerationY = forceY / self.mass

        self.velocity.dx += accelerationX * CGFloat(deltaTime)
        self.velocity.dy += accelerationY * CGFloat(deltaTime)
    }
}

enum Axis {
    case horizontal, vertical
}

enum BoundsSide {
    case left, right, top, bottom
}
