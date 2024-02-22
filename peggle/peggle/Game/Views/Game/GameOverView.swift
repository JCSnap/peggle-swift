//
//  GameOverView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 16/2/24.
//

import SwiftUI

struct GameOverView: View {
    var viewModel: GameOverViewDelegate
    var condition: GameStage

    var body: some View {
        UnclosableModalView(content: GameOverModalContent(viewModel: viewModel, condition: condition))
    }
}

struct GameOverModalContent: View {
    var viewModel: GameOverViewDelegate
    let condition: GameStage
    

    var body: some View {
        let text = condition == .lose ? "You lost" : "You won!"
        VStack {
            Text("\(text)")
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
