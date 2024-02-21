//
//  PhysicsObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 18/2/24.
//

import Foundation

protocol PhysicsObject {
    var center: CGPoint { get set }
    var velocity: CGVector { get set }
    var mass: CGFloat { get }
    var isStatic: Bool { get }
}
