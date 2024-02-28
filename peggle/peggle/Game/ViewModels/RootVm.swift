//
//  RootVm.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 16/2/24.
//

import Foundation

@Observable
class RootVm: HomeRootDelegate, LevelDesignerRootDelegate, GameRootDelegate {
    var soundManager: SoundManager
    var selectedTab: Int
    var selectedBoard: Board?
    var selectedPowerType: PowerType = Constants.defaultPowerType

    init() {
        self.soundManager = SoundManager()
        self.selectedTab = 0
    }
    
    func goToHomeView() {
        selectedTab = 0
    }

    func goToLevelDesignerView() {
        selectedTab = 1
    }

    func goToGameView() {
        selectedTab = 2
    }

    func goToGameViewWithBoard(_ board: Board) {
        selectedTab = 2
        selectedBoard = board
    }

    func clearBoardCache() {
        selectedBoard = nil
    }
    
    func playSound(sound: SoundType) {
        soundManager.playSound(sound: sound)
    }
}

protocol HomeRootDelegate: AnyObject {
    func playSound(sound: SoundType)
    func goToLevelDesignerView()
    func goToGameView()
}

protocol LevelDesignerRootDelegate: AnyObject {
    func playSound(sound: SoundType)
    func goToGameViewWithBoard(_ board: Board)
}

protocol GameRootDelegate: AnyObject {
    var selectedBoard: Board? { get }
    var selectedPowerType: PowerType { get set }

    func playSound(sound: SoundType)
    func goToHomeView()
    func goToLevelDesignerView()
    func clearBoardCache()
}
