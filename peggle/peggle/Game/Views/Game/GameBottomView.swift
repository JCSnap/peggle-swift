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
            if viewModel.canActivatePower && !viewModel.isAiming {
                Button(action: {
                    viewModel.activatePower()
                    activatedPower = true
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
    }
}

struct ActivatedPowerView: View {
    @State private var opacity: CGFloat = 1.0
    
    var body: some View {
        Text("Power Activated!")
            .font(.custom("Marker Felt", size: 30))
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

protocol GameBottomViewDelegate: AnyObject {
    var isAiming: Bool { get }
    var canActivatePower: Bool { get }

    func startGame()
    func activatePower()
}
