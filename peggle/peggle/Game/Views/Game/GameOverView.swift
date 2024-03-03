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
        let titleColor: any ShapeStyle = condition == .lose ? .red : .green

        VStack {
            MainText(text: text, size: 100, color: titleColor)
            MainText(text: "Score: \(viewModel.computedScore)", size: 40, color: .black)
            MainText(text: "Ball(s) Left: \(viewModel.ballCountRemaining)", size: 40, color: .black)
            MainText(text: "Orange: \(viewModel.score)/\(viewModel.maxScore)", size: 40, color: .black)
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
    var maxScore: Int { get }
    var computedScore: Int { get }

    func goToHomeView()
    func cleanUp()
}
