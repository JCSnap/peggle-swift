//
//  PhysicsBucket.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 21/2/24.
//

import Foundation

struct GameBucket: RectangularPhysicsObject & HittableObject {
    var bucket: Bucket
    var velocity: CGVector
    var mass: CGFloat
    var isStatic: Bool
    var center: CGPoint {
        get { bucket.center }
        set { bucket.center = newValue }
    }
    var angle: CGFloat = .zero
    var width: CGFloat {
        get { bucket.width }
        set { bucket.width = newValue }
    }
    var height: CGFloat {
        get { bucket.height }
        set { bucket.height = newValue }
    }
    
    init(bucket: Bucket, velocity: CGVector = Constants.defaultBucketVelocity, mass: CGFloat = Constants.defaultBucketMass) {
        self.bucket = bucket
        self.velocity = velocity
        self.mass = mass
        self.isStatic = true
    }
    
    // TODO: handle differently if collide is with side vs top (enter)
    func effectWhenHit(gameStateManager: inout PhysicsGameStateManager) {
        gameStateManager.handleBallEntersBucket()
    }
}
