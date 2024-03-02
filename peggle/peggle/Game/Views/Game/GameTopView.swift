//
//  GameTopView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameTopView: View {
    var viewModel: GameTopViewDelegate
    @State private var showMenuAlert = false    

    var body: some View {
        let menuText = "Exit to main menu? Your progress will not be saved!"
        
        HStack {
            Spacer()
            MenuView(showMenuAlert: $showMenuAlert)
            Spacer()
            BallCountView(viewModel: viewModel)
            Spacer()
            ScoreView(viewModel: viewModel)
            Spacer()
        }
        .frame(width: .infinity, height: 100)
        .alert(menuText, isPresented: $showMenuAlert) {
            Button("CANCEL", role: .cancel) { }
            Button("YES") { viewModel.goToHomeView() }
        }
    }
}

struct MenuView: View {
    @Binding var showMenuAlert: Bool
    
    var body: some View {
        Button("Menu") {
            showMenuAlert = true
        }
        .font(.largeTitle)
    }
}

struct BallCountView: View {
    var viewModel: GameTopViewDelegate

    var body: some View {
        HStack {
            Text("Ball(s) left:")
                .font(.largeTitle)
                .bold()
            Text("\(viewModel.ballCountRemaining)")
                .font(.largeTitle)
        }
    }
}
struct ScoreView: View {
    var viewModel: GameTopViewDelegate

    var body: some View {
        HStack {
            Text("Score:")
                .font(.largeTitle)
                .bold()
            Text("\(viewModel.score)/\(viewModel.maxScore)")
                .font(.largeTitle)
        }
    }
}

protocol GameTopViewDelegate: AnyObject {
    var ballCountRemaining: Int { get }
    var score: Int { get }
    var maxScore: Int { get }
    
    func goToHomeView()
}

#Preview {
    GameTopView(viewModel: GameVm(rootVm: RootVm()))
}
