//
//  PoopPower.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 3/3/24.
//

import Foundation

struct PoopPower: Power {
    var type: PowerType = .poop
    
    func effectWhenActivated(gameStateManager: GameStateManager) {
        gameStateManager.ball.type = .poop
        gameStateManager.ball.radius *= 4
        let powerDuration = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + powerDuration) {
            gameStateManager.ball.type = .normal
            gameStateManager.ball.radius /= 4
        }
    }
}
