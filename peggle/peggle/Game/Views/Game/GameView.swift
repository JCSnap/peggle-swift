//
//  GameView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameView: View {
    @State var gameVm: GameVm
    @State var isPowerSelected = false

    var body: some View {
        ZStack {
            if gameVm.renderGame {
                VStack {
                    GameTopView(viewModel: gameVm)
                    GameBoardView(viewModel: gameVm)
                    GameBottomView(viewModel: gameVm)
                }
                if !isPowerSelected {
                    UnclosableModalView(content: GameSelectPowerView(isPowerSelected: $isPowerSelected, viewModel: gameVm))
                }
            } else {
                GeometryReader { geometry in
                    GameLoadLevelView(viewModel: gameVm, boundsSize: geometry.size)
                        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                }
            }
            if gameVm.isGameOver == .lose {
                GameOverView(viewModel: gameVm, condition: .lose)
            } else if gameVm.isGameOver == .win {
                GameOverView(viewModel: gameVm, condition: .win)
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
