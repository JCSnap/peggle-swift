//
//  PhysicsPeg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 15/2/24.
//

import Foundation

class PhysicsPeg: RoundPhysicsObject & PhysicsPegBehaviour {
    private var peg: Peg
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
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
                                 mass: CGFloat = Constants.defaultPegMass) -> PhysicsPeg {
        switch peg.type {
        case .blue:
            return BluePhysicsPeg(peg: peg, velocity: velocity, mass: mass)
        case .orange:
            return OrangePhysicsPeg(peg: peg, velocity: velocity, mass: mass)
        }
    }

    init(peg: Peg, velocity: CGVector, mass: CGFloat) {
        self.peg = peg
        self.velocity = velocity
        self.isStatic = true
        if mass <= 0 {
            self.mass = Constants.defaultPegMass
        } else {
            self.mass = mass
        }
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

    func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        collisionCount += 1
    }
}

class BluePhysicsPeg: PhysicsPeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
        }
    }
}

class OrangePhysicsPeg: PhysicsPeg {
    override func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        super.effectWhenHit(gameStateManager: &gameStateManager)
        if !self.isGlowing {
            self.glowUp()
            gameStateManager.score += 1
        }
    }
}
