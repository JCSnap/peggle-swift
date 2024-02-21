//
//  GameTopView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameTopView: View {
    var viewModel: GameTopViewDelegate

    var body: some View {
        HStack {
            Spacer()
            MenuView()
            Spacer()
            BallCountView(viewModel: viewModel)
            Spacer()
            ScoreView(viewModel: viewModel)
            Spacer()
        }
        .frame(width: .infinity, height: 100)
    }
}

struct MenuView: View {
    var body: some View {
        Button("Menu") {
            print("This is the meny button")
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
}

#Preview {
    GameTopView(viewModel: GameVm(rootVm: RootVm()))
}
