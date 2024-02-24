//
//  PhysicsPeg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 15/2/24.
//

import Foundation

class GamePeg: GameObject, RoundPhysicsObject {
    private var peg: Peg
    var collisionCount: Int = 0
    var isGlowing: Bool {
        peg.isGlowing
    }
    var isVisible = true
    var center: CGPoint {
        get { peg.center }
        set { peg.center = newValue }
    }
    var radius: CGFloat {
        peg.radius
    }
    var type: PegType {
        peg.type
    }

    // factory
    static func createPhysicsPeg(from peg: Peg,
                                 velocity: CGVector = Constants.defaultPegVelocity,
                                 mass: CGFloat = Constants.defaultPegMass) -> GamePeg {
        switch peg.type {
        case .normal:
            return BluePhysicsPeg(peg: peg, velocity: velocity, mass: mass)
        case .scoring:
            return OrangePhysicsPeg(peg: peg, velocity: velocity, mass: mass)
        }
    }

    init(peg: Peg, velocity: CGVector, mass: CGFloat) {
        self.peg = peg
        let massToInit: CGFloat
        if mass <= 0 {
            massToInit = Constants.defaultPegMass
        } else {
            massToInit = mass
        }
        super.init(velocity: velocity, mass: massToInit, isStatic: true)
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

    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        collisionCount += 1
    }
}

class BluePhysicsPeg: GamePeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
        }
    }
}

class OrangePhysicsPeg: GamePeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.score += 1
        }
    }
}
