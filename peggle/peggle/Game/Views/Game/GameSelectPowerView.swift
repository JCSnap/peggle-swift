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
                            .font(.custom("Marker Felt", size: 15))
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
                            .font(.custom("Marker Felt", size: 15))
                    }
                }
                .border(selectedPowerType == .spookyBall ? Color.blue : Color.clear, width: 5)
                Button(action: {
                    selectedPowerType = .reverseGravity
                    viewModel.playSound(sound: .select)
                }) {
                    VStack {
                        PowerView(powerType: .reverseGravity)
                        Text("REVERSE GRAVITY")
                            .font(.custom("Marker Felt", size: 15))
                    }
                }
                .border(selectedPowerType == .reverseGravity ? Color.blue : Color.clear, width: 5)
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
