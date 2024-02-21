//
//  GameBoardView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameBoardView: View {
    var viewModel: GameBoardViewDelegate

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                ForEach(viewModel.pegs.indices, id: \.self) { _ in
                    PegsView(viewModel: viewModel)
                }
                BallView()
                    .position(viewModel.ball.center)
                CannonView()
                    .rotationEffect(.radians(Double(viewModel.cannonAngle)))
                    .position(CGPoint(x: viewModel.screenBounds.width / 2, y: geometry.safeAreaInsets.top))
                if viewModel.isAiming {
                    DottedLineShape(angle: viewModel.cannonAngle + (.pi / 2), length: 450)
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [5, 3]))
                        .foregroundColor(.white)
                        .position(x: viewModel.screenBounds.width / 2, y: geometry.safeAreaInsets.top)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let dragStart = CGPoint(x: geometry.size.width / 2, y: 0)
                        let dragPoint = gesture.location
                        viewModel.setCannonAngle(fromPoint: dragStart, toPoint: dragPoint)
                    }
            )
        }
        .frame(maxHeight: .infinity)
    }
}

struct PegsView: View {
    let viewModel: GameBoardViewDelegate

    var body: some View {
        ForEach(viewModel.pegs.indices, id: \.self) { index in
            if viewModel.pegs[index].isGlowing {
                PegView(pegType: viewModel.pegs[index].type, isGlowing: viewModel.pegs[index].isGlowing)
                    .position(viewModel.pegs[index].center)
                    .opacity(viewModel.pegs[index].isVisible ? 1 : 0)
                    .animation(
                        .easeOut(duration: Constants.defaultAnimationDuration),
                        value: viewModel.pegs[index].isVisible)
            } else {
                PegView(pegType: viewModel.pegs[index].type, isGlowing: viewModel.pegs[index].isGlowing)
                    .position(viewModel.pegs[index].center)
            }
        }
    }
}

struct CannonAndAimingView: View {
    let cannonAngle: CGFloat
    let isAiming: Bool
    let screenBounds: CGRect

    var body: some View {
        ZStack {
            CannonView()
                .rotationEffect(.radians(Double(cannonAngle)))
                .position(CGPoint(x: screenBounds.width / 2, y: 0))
            if isAiming {
                DottedLineShape(angle: cannonAngle + (.pi / 2), length: 450)
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [5, 3]))
                    .foregroundColor(.white)
                    .position(x: screenBounds.width / 2, y: 0) // Adjust y-position as needed
            }
        }
    }
}

struct DottedLineShape: Shape {
    var angle: CGFloat
    var length: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let startPoint = CGPoint(x: rect.midX, y: rect.midY)
        let endPoint = CGPoint(x: startPoint.x + length * cos(angle), y: startPoint.y + length * sin(angle))

        path.move(to: startPoint)
        path.addLine(to: endPoint)

        return path
    }
}

protocol GameBoardViewDelegate: AnyObject {
    var pegs: [PhysicsPeg] { get }
    var cannonAngle: CGFloat { get }
    var ball: PhysicsBall { get }
    var screenBounds: CGRect { get }
    var isAiming: Bool { get }

    func setCannonAngle(fromPoint: CGPoint, toPoint: CGPoint)
}

#Preview {
    GameBoardView(viewModel: GameVm(rootVm: RootVm()))
}
