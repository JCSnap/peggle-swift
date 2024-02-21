//
//  PhysicsObject.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

protocol RoundPhysicsObject: PhysicsObject {
    var center: CGPoint { get set }
    var velocity: CGVector { get set }
    var radius: CGFloat { get }
    var mass: CGFloat { get }
}
