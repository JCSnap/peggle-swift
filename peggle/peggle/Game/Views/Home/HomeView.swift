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
                Text("PEGGLE")
                    .font(.custom("Marker Felt", size: 200))
                    .foregroundStyle(.blue)
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
                Text(title)
                    .font(.custom("Marker Felt", size: 40))
                    .foregroundStyle(.black)
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
