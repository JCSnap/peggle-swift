//
//  WorldPhysicsTests.swift
//  physics-engineTests
//
//  Created by Justin Cheah Yun Fei on 10/2/24.
//

import XCTest
@testable import peggle

class WorldPhysicsTests: XCTestCase {

    func testApplyGravityObjectAtRest() {
        var object = TestBall(center: .zero)
        WorldPhysics.applyGravity(to: &object, deltaTime: 1.0)
        XCTAssertEqual(object.velocity.dy, -PhysicsEngineConstants.earthGravity,
                       "Gravity should be applied to an object at rest")
    }

    func testApplyGravityObjectMovingUpward() {
        var object = TestBall(center: .zero, velocity: CGVector(dx: 0, dy: 10.0))
        WorldPhysics.applyGravity(to: &object, deltaTime: 1.0)
        XCTAssertEqual(object.velocity.dy, 10.0 - PhysicsEngineConstants.earthGravity,
                       "Gravity should reduce the upward velocity of the object")
    }

    func testApplyGravityObjectMovingDownward() {
        var object = TestBall(center: .zero, velocity: CGVector(dx: 0, dy: -10.0))
        WorldPhysics.applyGravity(to: &object, deltaTime: 1.0)
        XCTAssertEqual(object.velocity.dy, -10.0 - PhysicsEngineConstants.earthGravity,
                       "Gravity should increase the downward velocity of the object")
    }

    func testApplyGravityWithZeroDeltaTime() {
        var object = TestBall(center: .zero)
        WorldPhysics.applyGravity(to: &object, deltaTime: 0.0)
        XCTAssertEqual(object.velocity.dy, 0.0,
                       "Gravity should not be applied when deltaTime is 0")
    }
}

struct TestBall: RoundPhysicsObject {
    var center: CGPoint
    var velocity: CGVector
    var radius: CGFloat
    var mass: CGFloat

    init(center: CGPoint, velocity: CGVector = CGVector(dx: 0, dy: 0), radius: Float = 10.0, mass: Float = 10.0) {
        self.center = center
        self.velocity = velocity
        self.radius = 10.0
        self.mass = 10.0
    }
}
