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
                    PegInteractiveView(peg: viewModel.pegs[index], index: index, viewModel: viewModel,
                                       radius: viewModel.pegs[index].radius, angle: viewModel.pegs[index].angle, isSelected: isSelected)
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
    var peg: Peg
    var index: Int
    var viewModel: LevelDesignerBoardDelegate
    var radius: CGFloat
    var angle: CGFloat
    var isSelected: Bool
    @State private var longPressTimer: Timer?

    var body: some View {
        PegView(pegType: peg.type, radius: radius, isGlowing: peg.isGlowing, orientation: .radians(angle))
            .position(peg.center)
            .gesture(DragGesture()
                .onChanged { value in
                    viewModel.updatePegPosition(index: index, newPoint: value.location)
                    longPressTimer?.invalidate()
                }
            )
            .onTapGesture {
                if !viewModel.isInsertMode {
                    viewModel.deletePeg(peg)
                } else {
                    viewModel.selectedObjectIndex = index
                }
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.8).onEnded { _ in
                viewModel.deletePeg(peg)
            })
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                longPressTimer?.invalidate()
            })
            .overlay(
                isSelected ? Rectangle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .frame(width: radius * 2, height: radius * 2)
                    .position(peg.center)
                : nil
            )
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
                    viewModel.addPeg(at: location)
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
    var selectedObjectIndex: Int { get set }

    func addPeg(at point: CGPoint)
    
    func setSelectedObjectToLastObject()

    func deletePeg(_ peg: Peg)

    func updatePegPosition(index: Int, newPoint: CGPoint)

    func setBoardSize(_ size: CGSize)
}
