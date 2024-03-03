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
            MainText(text: "Select Your Power", size: 50, color: .black)
            VStack {
                HStack {
                    Button(action: {
                        selectedPowerType = .exploding
                        viewModel.playSound(sound: .select)
                    }) {
                        VStack {
                            PowerView(powerType: .exploding)
                            MainText(text: "EXPLODING", size: 15, color: .black)
                        }
                    }
                    .border(selectedPowerType == .exploding ? Color.blue : Color.clear, width: 5)
                    Button(action: {
                        selectedPowerType = .spookyBall
                        viewModel.playSound(sound: .select)
                    }) {
                        VStack {
                            PowerView(powerType: .spookyBall)
                            MainText(text: "SPOOKYBALL", size: 15, color: .black)
                        }
                    }
                    .border(selectedPowerType == .spookyBall ? Color.blue : Color.clear, width: 5)
                    Button(action: {
                        selectedPowerType = .reverseGravity
                        viewModel.playSound(sound: .select)
                    }) {
                        VStack {
                            PowerView(powerType: .reverseGravity)
                            MainText(text: "REVERSE GRAVITY", size: 15, color: .black)
                        }
                    }
                    .border(selectedPowerType == .reverseGravity ? Color.blue : Color.clear, width: 5)
                }
                HStack {
                    Button(action: {
                        selectedPowerType = .poop
                        viewModel.playSound(sound: .select)
                    }) {
                        VStack {
                            PowerView(powerType: .poop)
                            MainText(text: "POOP", size: 15, color: .black)
                        }
                    }
                    .border(selectedPowerType == .poop ? Color.blue : Color.clear, width: 5)
                }
            }
            Button(action: {
                isPowerSelected = true
                viewModel.playSound(sound: .interface)
                viewModel.selectPowerType(selectedPowerType)
            }) {
                MainText(text: "OK", size: 50, color: .blue)
            }
        }
    }
}

protocol GameSelectPowerViewDelegate {
    func playSound(sound: SoundType)
    func selectPowerType(_ type: PowerType)
}
