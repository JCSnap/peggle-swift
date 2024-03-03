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

    private let powerTypes: [PowerType] = [.exploding, .spookyBall, .reverseGravity, .poop]
    private let powerTypeDisplayNames: [PowerType: String] = [
        .exploding: "Exploding",
        .spookyBall: "Spooky Ball",
        .reverseGravity: "Reverse Gravity",
        .poop: "Poop"
    ]
    
    var body: some View {
        
        VStack {
            MainText(text: "Select Your Power", size: 50, color: .black)
            HStack {
                ForEach(powerTypes, id: \.self) { powerType in
                    PowerSelectionButton(powerType: powerType,
                                         isSelected: selectedPowerType == powerType, action: {
                        selectedPowerType = powerType
                        viewModel.playSound(sound: .select)
                    }, displayName: powerTypeDisplayNames[powerType] ?? "")
                }
            }
            Button(action: confirmSelection) {
                MainText(text: "OK", size: 50, color: .blue)
            }
        }
    }
    
    private func confirmSelection() {
        isPowerSelected = true
        viewModel.playSound(sound: .interface)
        viewModel.selectPowerType(selectedPowerType)
    }
}


struct PowerSelectionButton: View {
    var powerType: PowerType
    var isSelected: Bool
    var action: () -> Void
    var displayName: String
    
    var body: some View {
        Button(action: action) {
            VStack {
                PowerView(powerType: powerType)
                MainText(text: displayName, size: 15, color: .black)
            }
        }
        .border(isSelected ? Color.blue : Color.clear, width: 5)
    }
}

protocol GameSelectPowerViewDelegate: AnyObject {
    func playSound(sound: SoundType)
    func selectPowerType(_ type: PowerType)
}
