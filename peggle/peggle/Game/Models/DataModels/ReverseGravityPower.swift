//
//  ReverseGravityPower.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 2/3/24.
//

import Foundation

struct ReverseGravityPower: Power {
    var type: PowerType = .reverseGravity

    func effectWhenActivated(gameStateManager: GameStateManager) {
        gameStateManager.reverseGravity = true
        print("reverse gravity activated")
        let powerDuration = 6.0
        DispatchQueue.main.asyncAfter(deadline: .now() + powerDuration) {
            gameStateManager.reverseGravity = false
        }
    }
}
