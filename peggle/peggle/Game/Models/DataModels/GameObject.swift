//
//  GameObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

class GameObject: HittableObject {
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    
    init (velocity: CGVector, mass: CGFloat, isStatic: Bool) {
        self.velocity = velocity
        self.mass = mass
        self.isStatic = isStatic
    }
    
    func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        print("Default behaviour is do nothing, override for new behaviour")
    }
}
