//
//  HomeView.swift
//  peggle
//  The root of the Home Screen
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @State var homeVm: HomeViewDelegate

    var body: some View {
        VStack {
            Text("PEGGLE")
                .font(.system(size: 100))
            Button("LEVEL DESIGNER") {
                homeVm.playSound(sound: .interface)
                homeVm.goToLevelDesignerView()
            }
            .font(.system(size: 70))
            Button("GAME") {
                homeVm.playSound(sound: .interface)
                homeVm.goToGameView()
            }
            .font(.system(size: 70))
        }
    }
}

protocol HomeViewDelegate: AnyObject {
    func playSound(sound: SoundType)
    func goToLevelDesignerView()

    func goToGameView()
}
