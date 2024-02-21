//
//  HomeView.swift
//  peggle
//  The root of the Home Screen
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct HomeView: View {
    @State var homeVm: HomeViewDelegate

    var body: some View {
        VStack {
            Text("PEGGLE")
                .font(.system(size: 100))
            Button("LEVEL DESIGNER") {
                homeVm.goToLevelDesignerView()
            }
            .font(.system(size: 70))
            Button("GAME") {
                homeVm.goToGameView()
            }
            .font(.system(size: 70))
        }
    }
}

protocol HomeViewDelegate: AnyObject {
    func goToLevelDesignerView()

    func goToGameView()
}
