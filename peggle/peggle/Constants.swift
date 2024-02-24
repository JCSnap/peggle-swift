//
//  Constants.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import Foundation

struct Constants {
    static let defaultAssetRadius = 20.0
    static let defaultMaxLevelNameLength = 30

    static let defaultPersistenceManager = LocalPersistenceManager.self

    static let timeInterval = 1.0 / 40.0 // 60 FPS

    static let defaultAnimationDuration = 2.0

    static let collisionThresholdToBeConsideredStuck = 30
    
    static let defaultPowerType: PowerType = .spookyBall
    
    static let defaultBlastRadius = 100.0
    static let defaultBlastDelay = 0.2

    static let defaultCannonForce = 8_000.0
    static let defaultCannonTimeInterval = 1.0
    
    static let defaultBucketSize = CGSize(width: 100, height: 100)
    static let defaultBucketMass = 20.0
    static let defaultBucketVelocity = CGVector(dx: 400.0, dy: 0)

    static let defaultPegMass = 1_000_000.0
    static let defaultPegVelocity = CGVector(dx: 0, dy: 0)

    static let defaultBallMass = 10.0
    static let defaultBallVelocity = CGVector(dx: 0, dy: 750.0)

    static let defaultBallCount = 5
}
