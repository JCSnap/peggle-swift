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
    var selectedPegType: PegType
    var board: Board
    var isInsertMode: Bool

    var persistenceManager: LevelPersistence.Type

    var isLoadLevelViewPresented = false

    init(rootVm: LevelDesignerRootDelegate) {
        self.selectedPegType = .normal
        self.board = Board()
        self.isInsertMode = true
        self.persistenceManager = Constants.defaultPersistenceManager
        self.rootVm = rootVm
    }
    
    var selectedObjectIndex: Int = 0

    // MARK: LevelDesignerBoardDelegate
    var pegs: [Peg] {
        board.objects.compactMap { object in
            guard let peg = object as? Peg else {
                return nil
            }
            return peg
        }
    }

    func addPeg(at point: CGPoint) {
        board.addPeg(at: point, withType: selectedPegType)
    }

    func deletePeg(_ peg: Peg) {
        board.deleteBoardObject(peg)
    }

    func updatePegPosition(index: Int, newPoint: CGPoint) {
        board.updatePegPosition(index: index, newPoint: newPoint)
    }
    
    func selectObjectIndex(_ index: Int) {
        selectedObjectIndex = index
        if let peg = board.objects[index] as? Peg {
            print(peg.radius)
        }
    }
    
    func updateObjectSize(index: Int, newSize: CGFloat) {
        let objectToEdit = board.objects[index]
        
        if let pegToEdit = objectToEdit as? Peg {
            let newPeg = Peg(center: pegToEdit.center, type: pegToEdit.type, radius: newSize)
            print("updating", pegToEdit.radius, " ", newPeg.radius)
            board.replaceObject(at: index, with: newPeg)
        }
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

    func toggleLoadLevelView() {
        self.isLoadLevelViewPresented.toggle()
    }

    // MARK: LevelDesignerPaletteDelegate
    func selectPegType(type: PegType) {
        self.selectedPegType = type
    }

    func toggleMode() {
        self.isInsertMode.toggle()
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
