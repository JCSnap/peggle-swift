//
//  GameView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameView: View {
    @State var gameVm: GameVm
    @State var isPowerSelected: Bool = false

    var body: some View {
        ZStack {
            if gameVm.renderGame {
                VStack {
                    GameTopView(viewModel: gameVm)
                    GameBoardView(viewModel: gameVm)
                    GameBottomView(viewModel: gameVm)
                }
                if !isPowerSelected {
                    UnclosableModalView(content: SelectPowerView(isPowerSelected: $isPowerSelected, gameVm: gameVm))
                }
            } else {
                GameLoadLevelView(viewModel: gameVm)
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

struct SelectPowerView: View {
    @Binding var isPowerSelected: Bool
    var gameVm: GameVm
    
    var body: some View {
        VStack {
            Text("Select your power")
                .font(.largeTitle)
                .foregroundStyle(.black)
            HStack {
                Button(action: {
                    isPowerSelected = true
                    gameVm.selectPowerType(.exploding)
                }) {
                    Text("EXPLODING")
                }
                Button(action: {
                    isPowerSelected = true
                    gameVm.selectPowerType(.spookyBall)
                }) {
                    Text("SPOOKYBALL")
                }
            }
        }
    }
}
