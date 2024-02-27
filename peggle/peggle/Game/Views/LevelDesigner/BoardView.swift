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
                    let isSelected = index == viewModel.selectedObjectIndex
                    let peg = viewModel.pegs[index]
                    PegInteractiveView(type: peg.type, center: peg.center, index: index, viewModel: viewModel,
                                       radius: peg.radius, isGlowing: peg.isGlowing, angle: peg.angle, isSelected: isSelected, peg: peg)
                    }
                ForEach(viewModel.obstacles.indices, id: \.self) { index in
                    let isSelected = index == viewModel.selectedObjectIndex
                    let obstacle = viewModel.obstacles[index]
                    ObstacleInteractiveView(viewModel: viewModel, type: obstacle.type, center: obstacle.center, index: index, size: obstacle.size, angle: obstacle.angle)
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

struct PegInteractiveView: View {
    // TODO: View should not have reference to model
    var type: ObjectType.PegType
    var center: CGPoint
    var index: Int
    var viewModel: LevelDesignerBoardDelegate
    var radius: CGFloat
    var isGlowing: Bool
    var angle: CGFloat
    var isSelected: Bool
    var peg: Peg
    @State private var longPressTimer: Timer?

    var body: some View {
        PegView(pegType: type, radius: radius, isGlowing: isGlowing, angle: .radians(angle))
            .position(center)
            .gesture(DragGesture()
                .onChanged { value in
                    viewModel.updatePegPosition(index: index, newPoint: value.location)
                    longPressTimer?.invalidate()
                }
            )
            .onTapGesture {
                if !viewModel.isInsertMode {
                    viewModel.deleteObject(peg)
                } else {
                    viewModel.selectedObjectIndex = index
                }
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.8).onEnded { _ in
                viewModel.deleteObject(peg)
            })
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                longPressTimer?.invalidate()
            })
            .overlay(
                isSelected ? Rectangle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)
                : nil
            )
    }
}

struct ObstacleInteractiveView: View {
    var viewModel: LevelDesignerBoardDelegate
    var type: ObjectType.ObstacleType
    var center: CGPoint
    var index: Int
    var size: CGFloat
    var angle: CGFloat

    var body: some View {
        ObstacleView(type: type, width: size * 5, height: size)
            .position(center)
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

protocol LevelDesignerBoardDelegate: AnyObject {
    var isInsertMode: Bool { get }
    var pegs: [Peg] { get }
    var obstacles: [Obstacle] { get }
    var selectedObjectIndex: Int { get set }

    func addObject(at point: CGPoint)
    
    func setSelectedObjectToLastObject()

    func deleteObject(_ object: BoardObject)

    func updatePegPosition(index: Int, newPoint: CGPoint)

    func setBoardSize(_ size: CGSize)
}
