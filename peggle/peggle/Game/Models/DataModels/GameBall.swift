//
//  PhysicsBall.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 15/2/24.
//

import Foundation

struct GameBall: RoundPhysicsObject {
    var ball: Ball
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    var center: CGPoint {
        get { ball.center }
        set { ball.center = newValue }
    }
    var radius: CGFloat {
        ball.radius
    }
    var angle: CGFloat = .zero

    init(ball: Ball, velocity: CGVector = Constants.defaultBallVelocity, mass: CGFloat = Constants.defaultBallMass) {
        self.ball = ball
        self.velocity = velocity
        self.isStatic = false
        if mass <= 0 {
            self.mass = Constants.defaultBallMass
        } else {
            self.mass = mass
        }
    }
}
