//
//  RectangularPhysicsObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 21/2/24.
//

import Foundation

protocol RectangularPhysicsObject: PhysicsObject {
    var center: CGPoint { get set }
    var velocity: CGVector { get set }
    var mass: CGFloat { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
}
