//
//  PhysicsGameStateManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 16/2/24.
//

import Foundation

@Observable
class GameStateManager {
    var level: Level?
    var ball = GameBall(ball: Ball(center: .zero))
    var ballCountRemaining: Int = Constants.defaultBallCount
    var objects: [GameObject] = []
    var bucket: GameBucket = GameBucket(bucket: Bucket(center: CGPoint(x: -100, y: -100)))
    var cannonAngle: CGFloat = .zero
    var computedScore: Int = 0
    var previousComputedScore: Int = 0
    var recentComputedScore: Int {
        computedScore - previousComputedScore
    }
    var scoreSize: CGFloat {
        let velocityRatio = ball.velocity.magnitude / Constants.defaultBallVelocity.magnitude
        let scaleFactor = 40.0 // this is arbitrary
        return velocityRatio * scaleFactor
    }
    var score: Int = 0
    var finalScore: Int?
    var isGameOver: GameStage = .playing
    var screenBounds = CGRect(origin: .zero, size: .zero)
    var hasLevel: Bool {
        level != nil
    }
    var maxScore: Int = 0
    var allowBallExitToInterruptPlayAndRemovePegs: Bool = true
    var reverseGravity: Bool = false

    func hasReachedObjective() -> Bool {
        let gamePegs = objects.compactMap { $0 as? GamePeg }
        return !gamePegs.contains(where: { $0.type == .scoring && !$0.isGlowing })
    }

    func initialiseStartStates() {
        ball.isStatic = false
        ball.velocity = .zero
        ball.applyForceWithAngle(deltaTime: Constants.defaultCannonTimeInterval, radian: cannonAngle, force: Constants.defaultCannonForce)
    }

    func initialiseLevelProperties(level: Level) {
        self.level = level
        self.screenBounds = CGRect(origin: .zero, size: level.board.boardSize)
        self.objects = level.board.objects.compactMap { object in
            if let peg = object as? Peg {
                return GamePeg.createGamePeg(from: peg)
            } else if let obstacle = object as? Obstacle {
                return GameObstacle.createGameObstacle(from: obstacle)
            }
            return nil
        }
        self.ball.center = ScreenPosition.topCenter.point(for: screenBounds)
        self.bucket.center = ScreenPosition.bottomCenter.point(for: screenBounds)
        self.maxScore = objects.compactMap { $0 as? GamePeg }.filter { $0.type == .scoring }.count
    }

    func updateObjects(for timeInterval: TimeInterval) {
        ball.updateObjectPosition(timeInterval: timeInterval)
        bucket.updateObjectPosition(timeInterval: timeInterval)
        for index in objects.indices {
            var object = objects[index]
            object.updateObjectPosition(timeInterval: timeInterval)
            objects[index] = object
        }
    }

    func setGameOver(with result: GameStage) {
        isGameOver = result
    }

    func handleBallExitScreen() {
        if !allowBallExitToInterruptPlayAndRemovePegs {
            makeBallReappearAtTopAtTheSameXPosition()
        } else {
            stopBallAndRepositionBallConditionallyBasedOnBallCount()
        }
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
    
    func addComputedScore(_ score: Int) {
        self.computedScore += score
    }
    
    func updatePreviousComputedScore() {
        previousComputedScore = computedScore
    }
    
    func addComputedScoreBasedOnBallSpeed() {
        let defaultSpeed = Constants.defaultBallVelocity.magnitude
        let currentSpeed = ball.velocity.magnitude
        // score is calculated based on relative speed of the ball to its default speed, scale factor is arbitrary
        let scaleFactor = 50.0
        let scoreToAdd = Int(currentSpeed / defaultSpeed * scaleFactor)
        addComputedScore(scoreToAdd)
    }
    
    func updateComputedScoreBasedOnBallRemaining() {
        let scaleFactor = 500
        addComputedScore(scaleFactor * ballCountRemaining)
    }

    func removeObjectsPrematurelyWith(collisionsMoreThan threshold: Int) {
        objects.forEach { object in
            if let gamePeg = object as? GamePeg, gamePeg.collisionCount > threshold {
                gamePeg.isVisible = false
            }
        }
        objects = objects.filter { object in
            if let obstacle = object as? GameObstacle {
                return obstacle.collisionCount <= threshold
            }
            return true
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
            if let gamePeg = object as? GamePeg, gamePeg.hasNoHealth {
                gamePeg.isVisible = false
            }
        }
    }
 
    func explodeExplodingPegs(withRadius: CGFloat = Constants.defaultBlastRadius) {
        let explodingPegs = objects.compactMap { $0 as? GamePeg }.filter { $0.type == .exploding }
            for peg in objects.compactMap({ $0 as? GamePeg }) {
                for explodingPeg in explodingPegs {
                    let distance = explodingPeg.peg.distance(from: peg.center)
                    if distance <= withRadius {
                        peg.effectWhenHit(gameStateManager: self)
                        peg.isVisible = false
                    }
                }
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.defaultBlastDelay) {
            self.removeInvisiblePegs()
        }
    }
    
    func createEffectWhereBallWillNotLeaveScreen() {
        ball.type = .spooky
        self.allowBallExitToInterruptPlayAndRemovePegs = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.allowBallExitToInterruptPlayAndRemovePegs = true
            self.ball.type = .normal
        }
    }
    
    func cleanUp() {
        cannonAngle = .zero
        level = nil
        objects = []
        ballCountRemaining = Constants.defaultBallCount
        score = 0
        computedScore = 0
        previousComputedScore = 0
        reverseGravity = false
        finalScore = nil
        isGameOver = .playing
    }

    private func hideBallFromScreen() {
        ball.center = CGPoint(x: -100, y: -100)
        ball.velocity = .zero
    }
    
    private func makeBallReappearAtTopAtTheSameXPosition() {
        let positionToReappear = CGPoint(x: ball.center.x, y: 10)
        // to prevent ball from accelerating too much
        let newVelocity = CGVector(dx: ball.velocity.dx / 2, dy: 0)
        self.ball = GameBall(ball: Ball(center: positionToReappear), velocity: newVelocity, type: ball.type)
    }
    
    private func stopBallAndRepositionBallConditionallyBasedOnBallCount() {
        if ballCountRemaining == 0 {
            hideBallFromScreen()
        } else {
            resetBallAtStartingPosition()
            ballCountRemaining -= 1
        }
        ball.isStatic = true
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
