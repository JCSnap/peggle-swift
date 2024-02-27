//
//  GameObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

class GameObject: HittableObject, PhysicsObject {
    var center: CGPoint
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    
    init (center: CGPoint, velocity: CGVector, mass: CGFloat, isStatic: Bool) {
        self.center = center
        self.velocity = velocity
        self.mass = mass
        self.isStatic = isStatic
    }
    
    func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        print("Default behaviour is do nothing, override for new behaviour")
    }
}
