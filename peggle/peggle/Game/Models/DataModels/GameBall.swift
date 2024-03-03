//
//  PhysicsBall.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 15/2/24.
//

import Foundation

struct GameBall: RoundPhysicsObject {
    var ball: Ball
    var type: BallType
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    var center: CGPoint {
        get { ball.center }
        set { ball.center = newValue }
    }
    var radius: CGFloat {
        get { ball.radius }
        set { ball.radius = newValue }
    }
    var angle: CGFloat = .zero

    init(ball: Ball, velocity: CGVector = Constants.defaultBallVelocity,
         mass: CGFloat = Constants.defaultBallMass, type: BallType = .normal) {
        self.ball = ball
        self.type = type
        self.velocity = velocity
        self.isStatic = false
        if mass <= 0 {
            self.mass = Constants.defaultBallMass
        } else {
            self.mass = mass
        }
    }
}

enum BallType {
    case normal, poop, spooky
}
