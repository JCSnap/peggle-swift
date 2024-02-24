//
//  SpookyBallPower.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

struct SpookyBallPower: Power {
    func effectWhenActivated(gameStateManager: inout PhysicsGameStateManager) {
        gameStateManager.createEffectWhereBallWillNotLeaveScreen()
    }
}
