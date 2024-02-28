//
//  SelectPowerView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 26/2/24.
//

import SwiftUI

struct GameSelectPowerView: View {
    @Binding var isPowerSelected: Bool
    var viewModel: GameSelectPowerViewDelegate
    @State private var selectedPowerType: PowerType = .exploding
    
    var body: some View {
        VStack {
            Text("Select your power")
                .font(.largeTitle)
                .foregroundStyle(.black)
            HStack {
                Button(action: {
                    selectedPowerType = .exploding
                    viewModel.playSound(sound: .select)
                }) {
                    VStack {
                        PowerView(powerType: .exploding)
                        Text("EXPLODING")
                    }
                }
                .border(selectedPowerType == .exploding ? Color.blue : Color.clear, width: 5)
                Button(action: {
                    selectedPowerType = .spookyBall
                    viewModel.playSound(sound: .select)
                }) {
                    VStack {
                        PowerView(powerType: .spookyBall)
                        Text("SPOOKYBALL")
                    }
                }
                .border(selectedPowerType == .spookyBall ? Color.blue : Color.clear, width: 5)
            }
            Button("OK") {
                isPowerSelected = true
                viewModel.playSound(sound: .interface)
                viewModel.selectPowerType(selectedPowerType)
            }
        }
    }
}

protocol GameSelectPowerViewDelegate {
    func playSound(sound: SoundType)
    func selectPowerType(_ type: PowerType)
}
