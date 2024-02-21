//
//  ContentView.swift
//  peggle
//  Architecture following: https://matteomanferdini.com/mvvm-swiftui/
//
//  Created by Justin Cheah Yun Fei on 22/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var rootVm = RootVm()

    var body: some View {
        TabView(selection: $rootVm.selectedTab) {
            HomeView(homeVm: HomeVm(rootVm: rootVm))
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            LevelDesignerView(levelDesignerVm: LevelDesignerVm(rootVm: rootVm))
                .tabItem {
                    Label("Level Designer", systemImage: "pencil.circle.fill")
                }
                .tag(1)
            GameView(gameVm: GameVm(rootVm: rootVm))
                .tabItem {
                    Label("Start Game", systemImage: "gamecontroller.fill")
                }
                .tag(2)
        }
        .accessibilityIdentifier("MainNavigationTab")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
