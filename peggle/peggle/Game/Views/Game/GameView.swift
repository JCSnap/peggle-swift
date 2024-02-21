//
//  GameView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameView: View {
    @State var gameVm: GameVm

    var body: some View {
        ZStack {
            if gameVm.renderGame {
                VStack {
                    GameTopView(viewModel: gameVm)
                    GameBoardView(viewModel: gameVm)
                    GameBottomView(viewModel: gameVm)
                }
            } else {
                GameLoadLevelView(viewModel: gameVm)
            }
            if gameVm.isGameOver {
                GameOverView(viewModel: gameVm)
            }
        }
        .onAppear {
            gameVm.checkForBoardToLoad()
        }
        .onDisappear {
            gameVm.cleanUp()
        }
    }
}
