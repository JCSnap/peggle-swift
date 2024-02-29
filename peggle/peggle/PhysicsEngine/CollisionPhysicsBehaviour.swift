//
//  CollisionPhysicsBehaviour.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 29/2/24.
//

import Foundation

protocol CollisionPhysicsBehaviour {
    mutating func handleBoundaryCollision(within bounds: CGRect, applyPositiomalCorrection: Bool)
    mutating func handleCollision<T: RoundPhysicsObject>(with object: inout T)
    mutating func handleCollision<T: RectangularPhysicsObject>(with object: inout T)
    func isColliding<T: RoundPhysicsObject>(with object: T) -> Bool
    func isColliding<T: RectangularPhysicsObject>(with object: T) -> Bool
}

extension CollisionPhysicsBehaviour {
    mutating func handleBoundaryCollision(within bounds: CGRect, applyPositiomalCorrection: Bool = true) {
        handleBoundaryCollision(within: bounds, applyPositiomalCorrection: applyPositiomalCorrection)
    }
}
