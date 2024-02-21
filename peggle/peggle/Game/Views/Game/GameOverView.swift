//
//  GameOverView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 16/2/24.
//

import SwiftUI

struct GameOverView: View {
    var viewModel: GameOverViewDelegate

    var body: some View {
        UnclosableModalView(content: GameOverModalContent(viewModel: viewModel))
    }
}

struct GameOverModalContent: View {
    var viewModel: GameOverViewDelegate

    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .foregroundStyle(.black)
            Text("Score: \(viewModel.score)")
                .font(.title2)
                .foregroundStyle(.black)
            Text("Ball(s) Remaining: \(viewModel.ballCountRemaining)")
                .font(.title2)
                .foregroundStyle(.black)
            Button("Return to Home") {
                viewModel.goToHomeView()
            }
            .font(.largeTitle)
        }
    }
}

protocol GameOverViewDelegate: AnyObject {
    var ballCountRemaining: Int { get }
    var score: Int { get }

    func goToHomeView()
    func cleanUp()
}
