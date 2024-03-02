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
    @State var showPoopOverlay: Bool = false

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
                    if viewModel.selectedPowerType == .poop {
                        showPoopOverlay = true
                    }
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
            showPoopOverlay ? PoopView() : nil,
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

struct PoopView: View {
    @State private var opacity: CGFloat = 1.0
    
    var body: some View {
        MainText(text: "It's POOP TIME", size: 100, color: .brown)
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
}

protocol GameBottomViewDelegate: AnyObject {
    var isAiming: Bool { get }
    var canActivatePower: Bool { get }
    var selectedPowerType: PowerType { get }
    
    func startGame()
    func activatePower()
}
