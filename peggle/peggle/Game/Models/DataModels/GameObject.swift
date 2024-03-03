//
//  GameObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import Foundation

class GameObject: HittableObject, PhysicsObject {
    var center: CGPoint
    var angle: CGFloat
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    var collisionCount: Int = 0
    
    init (center: CGPoint, angle: CGFloat = .zero, velocity: CGVector, mass: CGFloat, isStatic: Bool) {
        self.center = center
        self.angle = angle
        self.velocity = velocity
        self.mass = mass
        self.isStatic = isStatic
    }
    
    func effectWhenHit(gameStateManager: GameStateManager) {
        collisionCount += 1
    }
}

extension GameObject: Hashable {
    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        lhs.center == rhs.center
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(center)
    }
}
