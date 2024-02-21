//
//  CollisionPhysics.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

struct CollisionPhysics {
    static func isObjectCollidingWithBoundarySide<T: RoundPhysicsObject>(object: T,
                                                                         bounds: CGRect,
                                                                         side: BoundsSide) -> Bool {
        switch side {
        case .left:
            return object.center.x - object.radius <= bounds.minX
        case .right:
            return object.center.x + object.radius >= bounds.maxX
        case .top:
            return object.center.y - object.radius <= bounds.minY
        case .bottom:
            return object.center.y + object.radius >= bounds.maxY
        }
    }
}

enum Axis {
    case horizontal, vertical
}

enum BoundsSide {
    case left, right, top, bottom
}

protocol CollisionPhysicsBehaviour {
    mutating func handleBoundaryCollision(within bounds: CGRect)
}
