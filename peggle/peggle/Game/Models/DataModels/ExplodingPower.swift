//
//  ExplodingPower.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

struct ExplodingPower: Power {
    var type: PowerType = .exploding

    func effectWhenActivated(gameStateManager: GameStateManager) {
        gameStateManager.explodeExplodingPegs()
    }
}
