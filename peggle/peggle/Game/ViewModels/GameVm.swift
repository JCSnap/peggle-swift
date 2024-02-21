//
//  GameVm.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import Foundation

@Observable
class GameVm:
    GameTopViewDelegate,
    GameBoardViewDelegate,
    GameBottomViewDelegate,
    GameLoadLevelViewDelegate,
    GameOverViewDelegate {
    private var rootVm: GameRootDelegate
    private var gameStateManager = PhysicsGameStateManager()
    private var persistenceManager: LevelPersistence.Type = Constants.defaultPersistenceManager
    private var timerManager = TimerManager(timeInterval: Constants.timeInterval)

    var level: Level? {
        gameStateManager.level
    }
    var ball: PhysicsBall {
        get { gameStateManager.ball }
        set { gameStateManager.ball = newValue }
    }
    var pegs: [PhysicsPeg] {
        get { gameStateManager.pegs }
        set { gameStateManager.pegs = newValue }
    }
    var bucket: PhysicsBucket {
        get { gameStateManager.bucket }
        set { gameStateManager.bucket = newValue }
    }
    var cannonAngle: CGFloat {
        get { gameStateManager.cannonAngle }
        set { gameStateManager.cannonAngle = newValue }
    }
    var ballCountRemaining: Int {
        gameStateManager.ballCountRemaining
    }
    var score: Int {
        gameStateManager.score
    }
    var maxScore: Int {
        gameStateManager.maxScore
    }
    var finalScore: Int? {
        get { gameStateManager.finalScore }
        set { gameStateManager.finalScore = newValue }
    }
    var isAiming = true
    var isGameOver: Bool {
        gameStateManager.isGameOver
    }
    var screenBounds: CGRect {
        gameStateManager.screenBounds
    }
    var renderGame: Bool {
        gameStateManager.hasLevel
    }
    private var cleanupWorkItem: DispatchWorkItem?

    init(rootVm: GameRootDelegate) {
        self.rootVm = rootVm
    }

    func getNamesOfAvailableLevels() -> [String] {
        persistenceManager.displayAllLevels()
    }

    func checkForBoardToLoad() {
        guard let board = rootVm.selectedBoard else {
            return
        }
        let level = Level(name: "UNNAMED BOARD", board: board)
        gameStateManager.initialiseLevelProperties(level: level)
        rootVm.clearBoardCache()
    }

    func setLevelFromPersistenceAndRenderGame(levelName: String) {
        guard let level = persistenceManager.loadLevel(with: levelName) else {
            return
        }
        gameStateManager.initialiseLevelProperties(level: level)
    }

    func setCannonAngle(fromPoint dragStart: CGPoint, toPoint dragPoint: CGPoint) {
        let diff = CGPoint(x: dragPoint.x - dragStart.x, y: dragPoint.y - dragStart.y)
        let angle = atan2(diff.y, diff.x) - .pi / 2
        let clampedAngle = max(min(angle, .pi / 2), -.pi / 2)

        gameStateManager.cannonAngle = clampedAngle
    }

    func startGame() {
        isAiming = false
        gameStateManager.initialiseStartStates()
        timerManager.startTimer(update: self.updateGameState)
    }

    private func updateGameState() {
        gameStateManager.updateObjects(for: timerManager.timeInterval)
        WorldPhysics.applyGravity(to: &ball, deltaTime: timerManager.timeInterval)
        ball.handleBoundaryCollision(within: screenBounds)
        bucket.handleBoundaryCollision(within: screenBounds)
        checkAndHandleBallStuck()
        checkAndHandleBallExit()
        ball.handleCollision(with: &bucket)
        for i in 0..<pegs.count {
            if ball.isColliding(with: pegs[i]) {
                pegs[i].effectWhenHit(gameStateManager: &gameStateManager)
            }
            ball.handleCollision(with: &pegs[i])
        }
    }

    // a peg is to "stuck-causing" if its collision count is greater than an arbitrary threshold
    private func checkAndHandleBallStuck() {
        let isBallStuck = pegs.contains(where: { $0.collisionCount > Constants.collisionThresholdToBeConsideredStuck })
        if isBallStuck {
            gameStateManager.removePegsPrematurelyWith(collisionsMoreThan:
                                                        Constants.collisionThresholdToBeConsideredStuck)
        }
    }

    private func checkAndHandleBallExit() {
        if !CollisionPhysics.isObjectCollidingWithBoundarySide(object: ball, bounds: screenBounds, side: .bottom) {
            return
        }
        gameStateManager.handleBallExitScreen()
        gameStateManager.markGlowingPegsForRemoval()
        timerManager.invalidateTimer()
        // wait for animation to complete
        let workItem = DispatchWorkItem {
            self.isAiming = true
            self.gameStateManager.removeInvisiblePegs()
            if self.gameStateManager.ballCountRemaining == 0 || self.gameStateManager.hasReachedObjective() {
                self.endGame()
            }
        }
        cleanupWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.defaultAnimationDuration, execute: workItem)
    }

    private func endGame() {
        finalScore = score
        timerManager.invalidateTimer()
        gameStateManager.setGameOver()
    }

    func goToHomeView() {
        rootVm.goToHomeView()
    }

    func goToLevelDesignerView() {
        rootVm.goToLevelDesignerView()
    }

    func cleanUp() {
        gameStateManager.cleanUp()
        timerManager.invalidateTimer()
        self.isAiming = true
        cleanupWorkItem?.cancel()
        cleanupWorkItem = nil
    }

    deinit {
        timerManager.invalidateTimer()
    }
}

enum ScreenPosition {
    case topLeft
    case topCenter
    case topRight
    case bottomLeft
    case bottomCenter
    case bottomRight

    func point(for screenBounds: CGRect) -> CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0, y: 10)
        case .topCenter:
            return CGPoint(x: screenBounds.size.width / 2, y: 10)
        case .topRight:
            return CGPoint(x: screenBounds.size.width, y: 10)
        case .bottomLeft:
            return CGPoint(x: 0, y: screenBounds.size.height - 100)
        case .bottomCenter:
            return CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height - 100)
        case .bottomRight:
            return CGPoint(x: screenBounds.size.width, y: screenBounds.size.height - 100)
        }
    }
}
