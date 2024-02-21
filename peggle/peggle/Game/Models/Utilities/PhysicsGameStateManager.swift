//
//  PhysicsGameStateManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 16/2/24.
//

import Foundation

@Observable
class PhysicsGameStateManager {
    var level: Level?
    var ball = PhysicsBall(ball: Ball(center: .zero))
    var ballCountRemaining: Int = Constants.defaultBallCount
    var pegs: [PhysicsPeg] = []
    var bucket: PhysicsBucket = PhysicsBucket(bucket: Bucket(center: CGPoint(x: -100, y: -100)))
    var cannonAngle: CGFloat = .zero
    var score: Int = 0
    var finalScore: Int?
    var isGameOver = false
    var screenBounds = CGRect(origin: .zero, size: .zero)
    var hasLevel: Bool {
        level != nil
    }
    var maxScore: Int = 0

    func hasReachedObjective() -> Bool {
        !pegs.contains(where: { $0.type == .orange && !$0.isGlowing })
    }

    func initialiseStartStates() {
        ball.velocity = .zero
        bucket.center = ScreenPosition.bottomCenter.point(for: screenBounds)
        WorldPhysics.applyForceWithAngle(to: &ball,
                                         deltaTime: Constants.defaultCannonTimeInterval,
                                         radian: cannonAngle,
                                         force: Constants.defaultCannonForce)
    }

    func initialiseLevelProperties(level: Level) {
        self.level = level
        self.screenBounds = CGRect(origin: .zero, size: level.board.boardSize)
        self.ball = PhysicsBall(ball: Ball(center: ScreenPosition.topCenter.point(for: screenBounds)))
        self.pegs = level.board.pegs.map {peg -> PhysicsPeg in
            PhysicsPeg.createPhysicsPeg(from: peg)
        }
        self.maxScore = pegs.filter { $0.type == .orange }.count
    }

    func updateObjects(for timeInterval: TimeInterval) {
        WorldPhysics.updateObjectPosition(object: &ball, timeInterval: timeInterval)
        WorldPhysics.updateObjectPosition(object: &bucket, timeInterval: timeInterval)
    }

    func setGameOver() {
        isGameOver = true
    }

    func handleBallExitScreen() {
        if ballCountRemaining == 0 {
            hideBallFromScreen()
        } else {
            resetBallAtStartingPosition()
            ballCountRemaining -= 1
        }
        resetAllCollisionCounts()
    }

    func removeInvisiblePegs() {
        pegs.removeAll { !$0.isVisible }
    }

    func removePegsPrematurelyWith(collisionsMoreThan threshold: Int) {
        for i in 0..<pegs.count where pegs[i].collisionCount > threshold {
            pegs[i].isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.defaultAnimationDuration) {
            self.removeInvisiblePegs()
        }
    }

    func resetAllCollisionCounts() {
        pegs.forEach { $0.resetCollisionCount() }
    }

    func markGlowingPegsForRemoval() {
        for i in 0..<pegs.count where pegs[i].isGlowing {
            pegs[i].isVisible = false
        }
    }

    func cleanUp() {
        cannonAngle = .zero
        level = nil
        pegs = []
        ballCountRemaining = Constants.defaultBallCount
        score = 0
        finalScore = nil
        isGameOver = false
    }

    private func hideBallFromScreen() {
        ball.center = CGPoint(x: -100, y: -100)
        ball.velocity = .zero
    }

    private func resetBallAtStartingPosition() {
        self.ball = PhysicsBall(ball: Ball(center: ScreenPosition.topCenter.point(for: screenBounds)),
                                velocity: Constants.defaultBallVelocity)
    }
}
