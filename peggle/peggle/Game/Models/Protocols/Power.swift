//
//  Power.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

protocol Power {
    func effectWhenActivated(gameStateManager: GameStateManager)
}

enum PowerType {
    case exploding, spookyBall, reverseGravity, poop
}
