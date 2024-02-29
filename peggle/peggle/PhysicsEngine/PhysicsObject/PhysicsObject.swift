//
//  PhysicsObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 18/2/24.
//

import Foundation

protocol PhysicsObject {
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
        // friction is proportional to velocity squared
        let frictionalForceMagnitude = frictionCoefficient * self.velocity.magnitude * self.velocity.magnitude
        let frictionalForceX = frictionalForceMagnitude * (self.velocity.dx / self.velocity.magnitude)
        let frictionalForceY = frictionalForceMagnitude * (self.velocity.dy / self.velocity.magnitude)
        
        self.velocity.dx -= frictionalForceX * CGFloat(deltaTime)
        
        self.velocity.dy -= frictionalForceY * CGFloat(deltaTime)
        // velocity will not change direction due to friction
        if self.velocity.dx.sign != frictionalForceX.sign {
            self.velocity.dx = 0
        }
        
        self.velocity.dy -= frictionalForceY * CGFloat(deltaTime)
        if self.velocity.dy.sign != frictionalForceY.sign {
            self.velocity.dy = 0
        }
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
