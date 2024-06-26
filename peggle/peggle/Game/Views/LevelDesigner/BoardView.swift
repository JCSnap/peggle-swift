//
//  BoardView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct BoardView: View {
    var viewModel: LevelDesignerBoardDelegate

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .zIndex(-3)

                ForEach(viewModel.pegs.indices, id: \.self) { index in
                    let peg = viewModel.pegs[index]
                    let absoluteIndex = viewModel.getIndex(of: peg)
                    let isSelected = absoluteIndex == viewModel.selectedObjectIndex
                    let pegView = PegView(pegType: peg.type, isGlowing: peg.isGlowing,
                                          radius: peg.radius, angle: .radians(peg.angle))
                    InteractiveView(content: pegView, viewModel: viewModel, object: peg, index: absoluteIndex)
                        .overlay(
                            isSelected ? Rectangle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .frame(width: peg.radius * 2, height: peg.radius * 2)
                                .position(peg.center)
                            : nil
                        )
                }
                ForEach(viewModel.obstacles.indices, id: \.self) { index in
                    let obstacle = viewModel.obstacles[index]
                    let absoluteIndex = viewModel.getIndex(of: obstacle)
                    let isSelected = absoluteIndex == viewModel.selectedObjectIndex
                    let obstacleView = ObstacleView(type: obstacle.type, size: obstacle.size, angle: obstacle.angle)
                    InteractiveView(content: obstacleView, viewModel: viewModel, object: obstacle, index: absoluteIndex)
                        .overlay(
                            isSelected ? Rectangle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .frame(width: obstacle.size * Constants.rectangleWidthToHeightRatio,
                                       height: obstacle.size)
                                .rotationEffect(.radians(obstacle.angle))
                                .position(obstacle.center)
                            : nil
                        )
                }

                InvisibleLayerView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.setBoardSize(geometry.size)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// To capture taps
struct InvisibleLayerView: View {
    var viewModel: LevelDesignerBoardDelegate
    @State var showWarning = false
    @State var warningLocation: CGPoint = .zero

    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture { location in
                if viewModel.isInsertMode {
                    viewModel.playSound(sound: .tick)
                    viewModel.addObject(at: location)
                    viewModel.setSelectedObjectToLastObject()
                } else {
                    warningLocation = CGPoint(x: location.x, y: location.y - 50) // prevent blocking by finger
                    showWarning = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showWarning = false
                    }
                }
            }
            .zIndex(-1)
            .frame(maxHeight: .infinity)
            .overlay(
                Group {
                    if showWarning {
                        Text("Undo button selected!")
                            .font(.title)
                            .position(warningLocation)
                            .transition(.opacity)
                    }
                }
            )
    }
}

struct InteractiveView<Content: View>: View {
    var content: Content
    var viewModel: LevelDesignerBoardDelegate
    var object: BoardObject
    var index: Int
    @State private var longPressTimer: Timer?

    var body: some View {
        content
            .position(object.center)
            .gesture(DragGesture()
                .onChanged { value in
                    viewModel.updateObjectPosition(index: index, newPoint: value.location)
                    longPressTimer?.invalidate()
                }
            )
            .onTapGesture {
                if !viewModel.isInsertMode {
                    viewModel.playSound(sound: .bubble)
                    viewModel.deleteObject(object)
                } else {
                    viewModel.selectedObjectIndex = viewModel.getIndex(of: object)
                }
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.8).onEnded { _ in
                viewModel.playSound(sound: .bubble)
                viewModel.deleteObject(object)
            })
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                longPressTimer?.invalidate()
            })
    }
}

protocol LevelDesignerBoardDelegate: AnyObject {
    var isInsertMode: Bool { get }
    var pegs: [Peg] { get }
    var obstacles: [Obstacle] { get }
    var selectedObjectIndex: Int { get set }

    func playSound(sound: SoundType)
    func addObject(at point: CGPoint)
    func getIndex(of object: BoardObject) -> Int
    func setSelectedObjectToLastObject()
    func deleteObject(_ object: BoardObject)
    func updateObjectPosition(index: Int, newPoint: CGPoint)
    func setBoardSize(_ size: CGSize)
}
