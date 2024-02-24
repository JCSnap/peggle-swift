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
    var ball = GameBall(ball: Ball(center: .zero))
    var ballCountRemaining: Int = Constants.defaultBallCount
    var objects: [GameObject] = []
    var bucket: GameBucket = GameBucket(bucket: Bucket(center: CGPoint(x: -100, y: -100)))
    var cannonAngle: CGFloat = .zero
    var score: Int = 0
    var finalScore: Int?
    var isGameOver: GameStage = .playing
    var screenBounds = CGRect(origin: .zero, size: .zero)
    var hasLevel: Bool {
        level != nil
    }
    var maxScore: Int = 0

    func hasReachedObjective() -> Bool {
        let gamePegs = objects.compactMap { $0 as? GamePeg }
        return !gamePegs.contains(where: { $0.type == .scoring && !$0.isGlowing })
    }

    func initialiseStartStates() {
        ball.isStatic = false
        ball.velocity = .zero
        WorldPhysics.applyForceWithAngle(to: &ball,
                                         deltaTime: Constants.defaultCannonTimeInterval,
                                         radian: cannonAngle,
                                         force: Constants.defaultCannonForce)
    }

    func initialiseLevelProperties(level: Level) {
        self.level = level
        self.screenBounds = CGRect(origin: .zero, size: level.board.boardSize)
        self.objects = level.board.objects.compactMap { object in
            guard let peg = object as? Peg else {
                return nil
            }
            return GamePeg.createPhysicsPeg(from: peg)
        }
        self.ball.center = ScreenPosition.topCenter.point(for: screenBounds)
        self.bucket.center = ScreenPosition.bottomCenter.point(for: screenBounds)
        self.maxScore = objects.compactMap { $0 as? GamePeg }.filter { $0.type == .scoring }.count
    }

    func updateObjects(for timeInterval: TimeInterval) {
        WorldPhysics.updateObjectPosition(object: &ball, timeInterval: timeInterval)
        WorldPhysics.updateObjectPosition(object: &bucket, timeInterval: timeInterval)
    }

    func setGameOver(with result: GameStage) {
        isGameOver = result
    }

    func handleBallExitScreen() {
        if ballCountRemaining == 0 {
            hideBallFromScreen()
        } else {
            resetBallAtStartingPosition()
            ballCountRemaining -= 1
        }
        ball.isStatic = true
        resetAllCollisionCounts()
    }
    
    func handleBallEntersBucket() {
        ballCountRemaining += 2
        handleBallExitScreen()
    }

    func removeInvisiblePegs() {
        objects.removeAll {
            if let gamePeg = $0 as? GamePeg {
                return !gamePeg.isVisible
            }
            return false
        }
    }

    func removePegsPrematurelyWith(collisionsMoreThan threshold: Int) {
        objects.forEach { object in
            if let gamePeg = object as? GamePeg, gamePeg.collisionCount > threshold {
                gamePeg.isVisible = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.defaultAnimationDuration) {
            self.removeInvisiblePegs()
        }
    }

    func resetAllCollisionCounts() {
        objects.forEach { object in
            (object as? GamePeg)?.resetCollisionCount()
        }
    }

    func markGlowingPegsForRemoval() {
        objects.forEach { object in
            if let gamePeg = object as? GamePeg, gamePeg.isGlowing {
                gamePeg.isVisible = false
            }
        }
    }

    func cleanUp() {
        cannonAngle = .zero
        level = nil
        objects = []
        ballCountRemaining = Constants.defaultBallCount
        score = 0
        finalScore = nil
        isGameOver = .playing
    }

    private func hideBallFromScreen() {
        ball.center = CGPoint(x: -100, y: -100)
        ball.velocity = .zero
    }
    
    private func resetBallAtStartingPosition() {
        self.ball = GameBall(ball: Ball(center: ScreenPosition.topCenter.point(for: screenBounds)),
                                velocity: Constants.defaultBallVelocity)
        self.ball.velocity = .zero
    }
}

enum GameStage {
    case playing, win, lose
}
