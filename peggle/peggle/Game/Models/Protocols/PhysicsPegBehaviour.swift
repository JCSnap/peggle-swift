//
//  PhysicsPegBehaviour.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 17/2/24.
//

import Foundation

protocol PhysicsPegBehaviour {
    func effectWhenHit(gameStateManager: inout PhysicsGameStateManager)

    func glowUp()
}
