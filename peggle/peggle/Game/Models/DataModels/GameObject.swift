//
//  GameObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

class GameObject: HittableObject, PhysicsObject {
    var center: CGPoint
    var angle: CGFloat
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    var collisionCount: Int = 0
    private var _health: CGFloat
    var health: CGFloat {
        get { _health }
        set { _health = min(max(newValue, 0), 100) }
    }

    init (center: CGPoint, angle: CGFloat = .zero, velocity: CGVector, mass: CGFloat, isStatic: Bool, health: CGFloat = Constants.defaultHealth) {
        self.center = center
        self.angle = angle
        self.velocity = velocity
        self.mass = mass
        self.isStatic = isStatic
        self._health = health
    }

    func deductHealthBasedOnImpact(impactVelocity: CGVector) {
        let defaultMagnitude = Constants.defaultBallVelocity.magnitude
        let scalingFactor = 3.0
        let toDeduct = impactVelocity.magnitude / (defaultMagnitude * scalingFactor) * Constants.defaultPegMaxHealth
        self.health -= toDeduct
    }

    func effectWhenHit(gameStateManager: GameStateManager) {
        collisionCount += 1
    }
}

extension GameObject: Hashable {
    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        lhs.center == rhs.center
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(center)
    }
}
