//
//  ViewModel.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 22/1/24.
//

import Foundation

@Observable
class LevelDesignerVm: LevelDesignerPaletteDelegate, LevelDesignerBoardDelegate, LevelDesignerLoadLevelDelegate {
    private var rootVm: LevelDesignerRootDelegate
    var selectedObjectType: ObjectType
    var board: Board
    var isInsertMode: Bool

    var persistenceManager: LevelPersistence.Type

    var isLoadLevelViewPresented = false

    init(rootVm: LevelDesignerRootDelegate) {
        self.selectedObjectType = .peg(.normal)
        self.board = Board()
        self.isInsertMode = true
        self.persistenceManager = Constants.defaultPersistenceManager
        self.rootVm = rootVm
    }
    
    var selectedObjectIndex: Int = 0

    // MARK: LevelDesignerBoardDelegate
    var objects: [BoardObject] {
        board.objects
    }
    var pegs: [Peg] {
        objects.compactMap { object in
            guard let peg = object as? Peg else {
                return nil
            }
            return peg
        }
    }
    var obstacles: [Obstacle] {
        objects.compactMap { object in
            guard let obstacle = object as? Obstacle else {
                return nil
            }
            return obstacle
        }
    }

    func addObject(at point: CGPoint) {
        switch selectedObjectType {
        case .peg(let pegType):
            board.addObject(Peg(center: point, type: pegType))
        case .obstacle(let obstacleType):
            board.addObject(Obstacle(center: point, type: obstacleType))
        }
    }
    
    func deleteObject(at index: Int) {
        if index >= objects.count {
            return
        }
        let object = objects[index]
        board.deleteBoardObject(object)
    }
    
    func deleteObject(_ object: BoardObject) {
        board.deleteBoardObject(object)
    }
    
    func getIndex(of object: BoardObject) -> Int {
        board.getIndexOf(object: object)
    }

    func updateObjectPosition(index: Int, newPoint: CGPoint) {
        board.updateObjectPosition(index: index, newPoint: newPoint)
    }
    
    func setSelectedObjectToLastObject() {
        selectedObjectIndex = objects.count - 1
    }
    
    func updateObjectSize(index: Int, newSize: CGFloat) {
        board.updateObjectSize(index: index, newSize: newSize)
    }
    
    func updateObjectAngle(index: Int, newAngleInDegree: CGFloat) {
        board.updateObjectAngle(index: index, newAngleInDegree: newAngleInDegree)
    }

    func setBoardSize(_ size: CGSize) {
        board.setBoardSize(size)
    }

    // MARK: LevelDesignerLoadLevelDelegate
    func getNamesOfAvailableLevels() -> [String] {
        persistenceManager.displayAllLevels()
    }

    func loadLevel(withName name: String) {
        // TODO: should display an alert instead of doing nothing
        guard let level = persistenceManager.loadLevel(with: name) else {
            return
        }
        // This should not happen if there is no cross device saving, or if oritentation is fixed
        if level.board.boardSize != board.boardSize {
            return
        }
        updateCurrentLevel(with: level)
    }
    
    func deleteLevel(_ levelName: String) {
        persistenceManager.deleteLevel(name: levelName)
    }

    func toggleLoadLevelView() {
        self.isLoadLevelViewPresented.toggle()
    }

    // MARK: LevelDesignerPaletteDelegate
    func selectObjectType(type: ObjectType) {
        self.selectedObjectType = type
    }

    func toggleMode() {
        self.isInsertMode.toggle()
    }
    
    func playSound(sound: SoundType) {
        rootVm.playSound(sound: sound)
    }

    func renderLoadLevelView() {
        isLoadLevelViewPresented = true
    }

    func saveLevel(levelName: String) {
        let newLevel = Level(name: levelName, board: board)
        persistenceManager.saveLevel(newLevel)
    }

    func resetLevel() {
        self.board = Board(withSize: board.boardSize)
    }

    func startLevel() {
        rootVm.goToGameViewWithBoard(board)
    }
    
    func isNameOverwriting(_ name: String) -> Bool {
        let levels = getNamesOfAvailableLevels()
        return levels.contains(name)
    }
    
    func cleanUp() {
        self.selectedObjectType = .peg(.normal)
        self.board = Board()
        self.isInsertMode = true
    }
}

extension LevelDesignerVm {
    func isNameInvalid(_ name: String) -> Bool {
        Validator.isNameInvalid(name)
    }
}

extension LevelDesignerVm {
    private func updateCurrentLevel(with level: Level) {
        self.board = level.board
    }
}
