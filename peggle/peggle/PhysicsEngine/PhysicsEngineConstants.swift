//
//  Constants.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation

struct PhysicsEngineConstants {
    static let factor = 200.0

    static let earthGravity = -9.81 * factor

    static let defaultFrictionCoefficient = 0.9

    static let bounceFactor = 1.7 // 1.2 to 2.0 for reasonable range

    static let defaultRestitution = CGFloat(1.0) // 1.0 for perfectly elastic collision

    static let timeInterval = 1.0 / 60.0 // 60 FPS
}
