//
//  GameBottomView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameBottomView: View {
    @State var viewModel: GameBottomViewDelegate
    @State var activatedPower: Bool = false
    @State var showPowerOverlay: Bool = false

    var body: some View {
        HStack {
            if viewModel.isAiming {
                Button("LAUNCH") {
                    viewModel.startGame()
                }
                .frame(width: 200, height: 100)
                .font(.largeTitle)
            }
            if viewModel.canActivatePower && !viewModel.isAiming {
                Button(action: {
                    viewModel.activatePower()
                    activatedPower = true
                    showPowerOverlay = true
                }) {
                    PowerOnView()
                }
            }
        }
        .frame(width: .infinity, height: 100)
        .overlay(
            activatedPower ? ActivatedPowerView() : nil,
            alignment: .top
        )
        .overlay(
            showPowerOverlay ? PowerOverlayView(powerSelected: viewModel.selectedPowerType) : nil,
            alignment: .top
        )
    }
}

struct ActivatedPowerView: View {
    @State private var opacity: CGFloat = 1.0
    
    var body: some View {
        MainText(text: "Power Activated", size: 30, color: .black)
            .frame(width: 500, height: 200)
            .foregroundStyle(.brown)
            .offset(y: -150)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        opacity = 0
                    }
                }
            }
    }
}

struct PowerOverlayView: View {
    @State private var opacity: CGFloat = 1.0
    var powerSelected: PowerType
    
    var body: some View {
        MainText(text: powerText, size: 100, color: powerTextColor)
            .frame(width: 700, height: 200)
            .foregroundStyle(.brown)
            .offset(y: -700)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        opacity = 0
                    }
                }
            }
    }
    
    private var powerText: String {
        let powerTexts: [PowerType: String] = [
            .exploding: "BOOM TIME 💥",
            .reverseGravity: "GRAVITY ◀️",
            .spookyBall: "GHOST 👻",
            .poop: "It's POOP TIME 💩"
        ]
        return powerTexts[powerSelected] ?? "POWER!"
    }
    
    private var powerTextColor: any ShapeStyle {
        let powerTextColors: [PowerType: any ShapeStyle] = [
            .exploding: .black,
            .reverseGravity: .green,
            .spookyBall: .white,
            .poop: .brown
        ]
        return powerTextColors[powerSelected] ?? .black
    }
}

protocol GameBottomViewDelegate: AnyObject {
    var isAiming: Bool { get }
    var canActivatePower: Bool { get }
    var selectedPowerType: PowerType { get }
    
    func startGame()
    func activatePower()
}
