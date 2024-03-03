//
//  PhysicsPeg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 15/2/24.
//

import Foundation

class GamePeg: GameObject, RoundPhysicsObject {
    var peg: Peg
    var isGlowing: Bool {
        peg.isGlowing
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
        super.init(center: peg.center, velocity: velocity, mass: massToInit, isStatic: isStatic, health: peg.health)
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

    override func effectWhenHit(gameStateManager: GameStateManager) {
        collisionCount += 1
    }
}

class NormalGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: GameStateManager) {
        super.effectWhenHit(gameStateManager: gameStateManager)
        gameStateManager.updatePreviousComputedScore()
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.addComputedScore(100)
            gameStateManager.addComputedScoreBasedOnBallSpeed()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}

class ScoringGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: GameStateManager) {
        super.effectWhenHit(gameStateManager: gameStateManager)
        gameStateManager.updatePreviousComputedScore()
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.score += 1
            gameStateManager.addComputedScore(500)
            gameStateManager.addComputedScoreBasedOnBallSpeed()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}

class ExplodingGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: GameStateManager) {
        super.effectWhenHit(gameStateManager: gameStateManager)
        gameStateManager.updatePreviousComputedScore()
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.addComputedScore(300)
            gameStateManager.addComputedScoreBasedOnBallSpeed()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}

class StubbornGamePeg: GamePeg {
    override func effectWhenHit(gameStateManager: GameStateManager) {
        super.effectWhenHit(gameStateManager: gameStateManager)
        gameStateManager.updatePreviousComputedScore()
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.addComputedScore(400)
            gameStateManager.addComputedScoreBasedOnBallSpeed()
        }
        deductHealthBasedOnImpact(impactVelocity: gameStateManager.ball.velocity)
    }
}
