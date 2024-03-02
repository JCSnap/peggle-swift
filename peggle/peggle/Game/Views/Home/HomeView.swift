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
        ZStack {
            Image("nature-background")
                .resizable()
                .scaledToFill()
            VStack {
                MainText(text: "PEGGLE", size: 200, color: .blue)
                MenuButton(
                    title: "LEVEL DESIGNER",
                    action: {
                        homeVm.playSound(sound: .interface)
                        homeVm.goToLevelDesignerView()
                    }
                )
                
                MenuButton(
                    title: "GAME",
                    action: {
                        homeVm.playSound(sound: .interface)
                        homeVm.goToGameView()
                    }
                )
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Image("brown-board")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 550)
                MainText(text: "\(title)", size: 40, color: .black)
            }
        }
    }
}

protocol HomeViewDelegate: AnyObject {
    func playSound(sound: SoundType)
    func goToLevelDesignerView()

    func goToGameView()
}

#Preview {
    HomeView(homeVm: HomeVm(rootVm: RootVm()))
}
