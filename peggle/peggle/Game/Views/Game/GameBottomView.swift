//
//  GameBottomView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameBottomView: View {
    @State var viewModel: GameBottomViewDelegate

    var body: some View {
        HStack {
            Text("This is the bottom view")
            if viewModel.isAiming {
                Button("LAUNCH") {
                    viewModel.startGame()
                }
                .frame(width: 200, height: 100)
                .font(.largeTitle)
            }
        }
        .frame(width: .infinity, height: 100)
    }
}

protocol GameBottomViewDelegate: AnyObject {
    var isAiming: Bool { get }

    func startGame()
}
