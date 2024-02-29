//
//  PhysicsPeg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 15/2/24.
//

import Foundation

class GamePeg: GameObject, RoundPhysicsObject {
    var peg: Peg
    var collisionCount: Int = 0
    var isGlowing: Bool {
        peg.isGlowing
    }
    private var _health: CGFloat
    var health: CGFloat {
        get { _health }
        set { _health = min(max(newValue, 0), 100) }
    }
    var isVisible = true
    override var center: CGPoint {
        get { peg.center }
        set { peg.center = newValue }
    }
    var radius: CGFloat {
        get { peg.radius }
        set { peg.radius = newValue }
    }
    override var angle: CGFloat {
        get { peg.angle }
        set { peg.angle = newValue }
    }
    var type: ObjectType.PegType {
        peg.type
    }
    var hasNoHealth: Bool {
        health == 0
    }

    // factory
    static func createGamePeg(from peg: Peg,
                                 velocity: CGVector = Constants.defaultPegVelocity,
                                 mass: CGFloat = Constants.defaultPegMass) -> GamePeg {
        switch peg.type {
        case .normal:
            return NormalGamePeg(peg: peg, velocity: velocity, mass: mass)
        case .scoring:
            return ScoringGamePeg(peg: peg, velocity: velocity, mass: mass)
        case .exploding:
            return ExplodingGamePeg(peg: peg, velocity: velocity, mass: mass)
        case .stubborn:
            return StubbornGamePeg(peg: peg, velocity: velocity, mass: Constants.stubbornPegMass, isStatic: false)
        }
    }

    init(peg: Peg, velocity: CGVector, mass: CGFloat, isStatic: Bool = true) {
        self.peg = peg
        let massToInit: CGFloat
        if mass <= 0 {
            massToInit = Constants.defaultPegMass
        } else {
            massToInit = mass
        }
        self._health = Constants.defaultPegMaxHealth
        super.init(center: peg.center, velocity: velocity, mass: massToInit, isStatic: isStatic)
    }

    func incrementCollisionCount() {
        collisionCount += 1
    }

    func resetCollisionCount() {
        collisionCount = 0
    }

    func glowUp() {
        peg.glowUp()
    }
    
    func deductHealthBasedOnImpact(impactVelocity: CGVector) {
        let defaultMagnitude = Constants.defaultBallVelocity.magnitude
        let scalingFactor = 3.0
        let toDeduct = impactVelocity.magnitude / (defaultMagnitude * scalingFactor) * Constants.defaultPegMaxHealth
        self.health -= toDeduct
    }

    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        collisionCount += 1
    }
}

class NormalGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}

class ScoringGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.score += 1
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}

class ExplodingGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}

class StubbornGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}
