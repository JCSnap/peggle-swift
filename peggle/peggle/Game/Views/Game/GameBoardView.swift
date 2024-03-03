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
                PegsView(viewModel: viewModel)
                ObstaclesView(viewModel: viewModel)
                BallView(radius: viewModel.ball.radius, ballType: viewModel.ball.type)
                    .position(viewModel.ball.center)
                CannonView()
                    .rotationEffect(.radians(Double(viewModel.cannonAngle)))
                    .position(CGPoint(x: viewModel.screenBounds.width / 2, y: geometry.safeAreaInsets.top))
                BucketView()
                    .position(viewModel.bucket.center)
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
        let pegs = viewModel.pegs

        ForEach(pegs.indices, id: \.self) { index in
            ZStack {
                if pegs[index].isGlowing {
                    PegView(pegType: pegs[index].type, radius: pegs[index].radius,
                            isGlowing: pegs[index].isGlowing, angle: .radians(pegs[index].angle))
                    .position(pegs[index].center)
                    .opacity(pegs[index].isVisible ? 1 : 0)
                    .animation(
                        .easeOut(duration: Constants.defaultAnimationDuration),
                        value: pegs[index].isVisible)
                } else {
                    PegView(pegType: pegs[index].type, radius: pegs[index].radius, isGlowing: pegs[index].isGlowing, angle: .radians(pegs[index].angle))
                        .position(pegs[index].center)
                }
                if viewModel.mostRecentCollisionObject == pegs[index] {
                    ComputedScoreView(score: viewModel.recentComputedScore, pegRadius: viewModel.pegs[index].radius, scoreSize: viewModel.scoreSize)
                        .position(pegs[index].center)
                }
                HealthBarView(health: viewModel.pegs[index].health, pegRadius: viewModel.pegs[index].radius)
                    .position(viewModel.pegs[index].center)
            }
        }

    }
}

struct HealthBarView: View {
    var health: CGFloat
    var pegRadius: CGFloat

    var body: some View {
        Rectangle()
            .fill(Color.green)
            .frame(width: health / 100 * pegRadius * 2, height: 5)
            .offset(y: -pegRadius - 5)
    }
}

struct ComputedScoreView: View {
    var score: Int
    var pegRadius: CGFloat
    @State var scoreSize: CGFloat
    @State private var opacity = 1.0

    var body: some View {
        MainText(text: "\(score)", size: scoreSize, color: .red)
            .offset(y: pegRadius + 5)
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

struct ObstaclesView: View {
    let viewModel: GameBoardViewDelegate

    var body: some View {
        let obstacles = viewModel.obstacles

        ForEach(obstacles.indices, id: \.self) { index in
            ObstacleView(type: obstacles[index].type, size: obstacles[index].size, angle: obstacles[index].angle)
                .position(obstacles[index].center)
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
    var pegs: [GamePeg] { get }
    var obstacles: [GameObstacle] { get }
    var cannonAngle: CGFloat { get }
    var ball: GameBall { get }
    var bucket: GameBucket { get }
    var screenBounds: CGRect { get }
    var isAiming: Bool { get }
    var recentComputedScore: Int { get }
    var scoreSize: CGFloat { get }
    var mostRecentCollisionObject: GameObject? { get }

    func setCannonAngle(fromPoint: CGPoint, toPoint: CGPoint)
}

#Preview {
    GameBoardView(viewModel: GameVm(rootVm: RootVm()))
}
