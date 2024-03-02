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
    GameOverViewDelegate,
    GameSelectPowerViewDelegate {
    private var rootVm: GameRootDelegate
    private var gameStateManager = GameStateManager()
    private var persistenceManager: LevelPersistence.Type = Constants.defaultPersistenceManager
    private var timerManager = TimerManager(timeInterval: Constants.timeInterval)
    private var power: Power = ExplodingPower()
    private let powerConstructors: [PowerType: () -> Power] = [
        .exploding: { ExplodingPower() },
        .spookyBall: { SpookyBallPower() }
    ]
    
    var level: Level? {
        gameStateManager.level
    }
    var ball: GameBall {
        get { gameStateManager.ball }
        set { gameStateManager.ball = newValue }
    }
    var pegs: [GamePeg] {
        get {
            gameStateManager.objects.compactMap { $0 as? GamePeg }
        }
        set(newPegs) {
            gameStateManager.objects = gameStateManager.objects.filter { !($0 is GamePeg) }
            gameStateManager.objects.append(contentsOf: newPegs)
        }
    }
    var obstacles: [GameObstacle] {
        get {
            gameStateManager.objects.compactMap { $0 as? GameObstacle }
        }
        set(newObstacle) {
            gameStateManager.objects = gameStateManager.objects.filter { !($0 is GameObstacle) }
            gameStateManager.objects.append(contentsOf: newObstacle)
        }
    }
    var objects: [GameObject] {
        get { gameStateManager.objects }
        set { gameStateManager.objects = newValue }
    }
    var bucket: GameBucket {
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
    var isGameOver: GameStage {
        gameStateManager.isGameOver
    }
    var screenBounds: CGRect {
        gameStateManager.screenBounds
    }
    var renderGame: Bool {
        gameStateManager.hasLevel
    }
    var selectedPowerType: PowerType {
        rootVm.selectedPowerType
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
        playSound(sound: .cannon)
        timerManager.startTimer(update: self.updateGameState)
    }
    
    func playSound(sound: SoundType) {
        rootVm.playSound(sound: sound)
    }
    
    func selectPowerType(_ type: PowerType) {
        rootVm.selectedPowerType = type
        self.power = powerConstructors[type]?() ?? ExplodingPower()

    }
    
    func activatePower() {
        power.effectWhenActivated(gameStateManager: &gameStateManager)
    }
    
    private func updateGameState() {
        ball.applyGravity(deltaTime: timerManager.timeInterval)
        checkAndHandleBoundaryCollisions()
        checkAndHandleBallStuck()
        checkAndHandleBallExit()
        if ball.isColliding(with: bucket) {
            bucket.effectWhenHit(gameStateManager: &gameStateManager)
            removePegAndTransitionToNextStage()
        }
        handleCollisions()
        gameStateManager.updateObjects(for: timerManager.timeInterval)
    }
    
    private func checkAndHandleBoundaryCollisions() {
        ball.handleBoundaryCollision(within: screenBounds)
        bucket.handleBoundaryCollision(within: screenBounds, applyPositionalCorrection: false)
        for object in objects {
            if var peg = object as? GamePeg {
                peg.applyFriction(deltaTime: timerManager.timeInterval)
                peg.handleBoundaryCollision(within: screenBounds)
            }
        }
    }
    // a peg is to "stuck-causing" if its collision count is greater than an arbitrary threshold
    private func checkAndHandleBallStuck() {
        let isBallStuck = self.pegs.contains(where: { $0.collisionCount > Constants.collisionThresholdToBeConsideredStuck })
        
        if isBallStuck {
            self.gameStateManager.removePegsPrematurelyWith(collisionsMoreThan: Constants.collisionThresholdToBeConsideredStuck)
        }
    }
    
    private func checkAndHandleBallExit() {
        let isBallExitingScreen = ball.isObjectCollidingWithBoundarySide(bounds: self.screenBounds, side: .bottom)
        
        if isBallExitingScreen {
            self.gameStateManager.handleBallExitScreen()
            if gameStateManager.allowBallExitToInterruptPlayAndRemovePegs {
                self.removePegAndTransitionToNextStage()
            }
        }
    }
    
    private func removePegAndTransitionToNextStage() {
        gameStateManager.markGlowingPegsForRemoval()
        playSound(sound: .clear)
        // wait for animation to complete
        let workItem = DispatchWorkItem {
            self.isAiming = true
            self.gameStateManager.removeInvisiblePegs()
            if self.gameStateManager.hasReachedObjective() {
                self.endGame(with: .win)
            } else if self.gameStateManager.ballCountRemaining == 0 {
                self.endGame(with: .lose)
            }
        }
        cleanupWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.defaultAnimationDuration, execute: workItem)
    }
    
    private func handleCollisions() {
        let objects = self.objects
        
        for object in objects {
            if var peg = object as? GamePeg {
                if self.ball.isColliding(with: peg) {
                    playSound(sound: .bounce)
                    peg.effectWhenHit(gameStateManager: &self.gameStateManager)
                    self.ball.handleCollision(with: &peg)
                }
            } else if var rectangleObstacle = object as? GameRectangleObstacle {
                if self.ball.isColliding(with: rectangleObstacle) {
                    playSound(sound: .bounce)
                    self.ball.handleCollision(with: &rectangleObstacle)
                }
            }
        }
 
        
        for i in 0..<objects.count {
            for j in (i + 1)..<objects.count {
                if var peg1 = self.objects[i] as? GamePeg, var peg2 = self.objects[j] as? GamePeg, peg1.isColliding(with: peg2) {
                    peg1.handleCollision(with: &peg2)
                    playSound(sound: .bounce)
                    self.objects[i] = peg1
                    self.objects[j] = peg2
                } else if var peg = self.objects[i] as? GamePeg, var obstacle = self.objects[j] as? GameRectangleObstacle, peg.isColliding(with: obstacle) {
                    if !peg.isStatic {
                        peg.handleCollision(with: &obstacle)
                        playSound(sound: .bounce)
                        self.objects[i] = peg
                        self.objects[j] = obstacle
                    }
                }
            }
        }
    }
    
    private func endGame(with result: GameStage) {
        finalScore = score
        timerManager.invalidateTimer()
        gameStateManager.setGameOver(with: result)
        if result == GameStage.win {
            playSound(sound: .win)
        } else if result == GameStage.lose {
            playSound(sound: .gameOver)
        }
    }
    
    func goToHomeView() {
        rootVm.goToHomeView()
    }
    
    func goToLevelDesignerView() {
        rootVm.goToLevelDesignerView()
    }
    
    func cleanUp() {
        for gamePeg in pegs {
            gamePeg.peg.isGlowing = false
        }
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
            return CGPoint(x: 0, y: screenBounds.size.height)
        case .bottomCenter:
            return CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height)
        case .bottomRight:
            return CGPoint(x: screenBounds.size.width, y: screenBounds.size.height)
        }
    }
}
