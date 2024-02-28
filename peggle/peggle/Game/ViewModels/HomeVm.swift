//
//  HomeVm.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import Foundation

@Observable
class HomeVm: HomeViewDelegate {
    private var rootVm: HomeRootDelegate

    init(rootVm: HomeRootDelegate) {
        self.rootVm = rootVm
    }
    
    func playSound(sound: SoundType) {
        rootVm.playSound(sound: sound)
    }

    func goToLevelDesignerView() {
        rootVm.goToLevelDesignerView()
    }

    func goToGameView() {
        rootVm.goToGameView()
    }
}
