//
//  GameBarView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct PaletteView: View {
    var viewModel: LevelDesignerPaletteDelegate
    @State private var levelName: String = ""
    @State private var showSaveAlert = false
    @State private var showInvalidNameAlert = false
    @State private var showCannotOverwritePreloadedLevel = false
    @State private var showOverwriteNameAlert = false
    @State private var showResetAlert = false

    var body: some View {
        let resetAlertText = "Are you sure you want to reset? This action cannot be reversed"
        let saveAlertText = "Save level with: \(levelName)?"
        let cannotOverwritePreloadedLevelText = "Level name cannot be the same as any preloaded level!"
        let overwriteNameAlertText = "\(levelName) already exists. Do you want to overwrite it?"
        let invalidNameAlertText = "Invalid Level Name"
        let invalidNameAlertMessage =
        """
        Please use a valid name that does not contain unsavable characters,
        consist only of whitespace, or more than 30 characters.
        """

        VStack {
            PegSelectionView(viewModel: viewModel)
            EditObjectView(viewModel: viewModel)
            ActionButtonsView(levelName: $levelName, showSaveAlert: $showSaveAlert,
                              showCannotOverwritePreloadedLevel: $showCannotOverwritePreloadedLevel,
                              showOverwriteNameAlert: $showOverwriteNameAlert,
                              showInvalidNameAlert: $showInvalidNameAlert,
                              showResetAlert: $showResetAlert, viewModel: viewModel)
            .alert(resetAlertText, isPresented: $showResetAlert) {
                Button("CANCEL", role: .cancel) { }
                Button("YES") { viewModel.resetLevel() }
            }
            .alert(saveAlertText, isPresented: $showSaveAlert) {
                Button("CANCEL", role: .cancel) { }
                Button("OK") {
                    viewModel.saveLevel(levelName: levelName)
                }
            }
            .alert(cannotOverwritePreloadedLevelText, isPresented: $showCannotOverwritePreloadedLevel) {
                Button("OK", role: .cancel) { }
            }
            .alert(overwriteNameAlertText, isPresented: $showOverwriteNameAlert) {
                Button("CANCEL", role: .cancel) { }
                Button("OK") {
                    viewModel.saveLevel(levelName: levelName)
                }
            }
            .alert(invalidNameAlertText, isPresented: $showInvalidNameAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(invalidNameAlertMessage)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct PegSelectionView: View {
    var viewModel: LevelDesignerPaletteDelegate
    let pegTypes: [(ObjectType.PegType, Color)] = [
        (.normal, Color.blue),
        (.scoring, Color.orange),
        (.exploding, Color.green),
        (.stubborn, Color.red)
    ]
    let objectTypes: [(ObjectType.ObstacleType, Color)] = [
        (.rectangle, Color.black)
    ]

    var body: some View {
        HStack {
            ForEach(pegTypes, id: \.0) { pegType, borderColor in
                Button(action: {
                    viewModel.playSound(sound: .select)
                    viewModel.selectObjectType(type: .peg(pegType))
                }) {
                    PegView(pegType: pegType, isGlowing: false)
                        .border(viewModel.selectedObjectType == .peg(pegType) ? borderColor : Color.clear, width: 3)
                }
            }
            ForEach(objectTypes, id: \.0) { objectType, borderColor in
                Button(action: {
                    viewModel.playSound(sound: .select)
                    viewModel.selectObjectType(type: .obstacle(objectType))
                }) {
                    ObstacleView(type: objectType, size: Constants.rectangleObstacleSize)
                        .border(viewModel.selectedObjectType == .obstacle(objectType) ?
                                borderColor : Color.clear, width: 3)
                }
            }
            Spacer()
            Button(action: {
                viewModel.playSound(sound: .select)
                viewModel.toggleMode()
            }) {
                DeleteButtonView()
                    .background(viewModel.isInsertMode ? Color.clear : Color.red.opacity(0.3))
                    .cornerRadius(5)
            }
        }
    }
}

struct EditObjectView: View {
    var viewModel: LevelDesignerPaletteDelegate
    @State private var sizeSliderValue: CGFloat = 0
    @State private var angleSliderValue: CGFloat = 0
    @State private var healthSliderValue: CGFloat = 0

    private var sizeBinding: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                guard !viewModel.objects.isEmpty
                        && viewModel.objects.indices.contains(viewModel.selectedObjectIndex) else {
                    return 0
                }
                return viewModel.objects[viewModel.selectedObjectIndex].size
            },
            set: {
                guard viewModel.objects.indices.contains(viewModel.selectedObjectIndex) else {
                    return
                }
                viewModel.updateObjectSize(index: viewModel.selectedObjectIndex, newSize: $0)
            }
        )
    }
    private var angleBinding: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                guard !viewModel.objects.isEmpty
                        && viewModel.objects.indices.contains(viewModel.selectedObjectIndex) else {
                    return 0
                }
                let angleInDegree = viewModel.objects[viewModel.selectedObjectIndex].angle * 180 / .pi
                return angleInDegree
            },
            set: {
                guard viewModel.objects.indices.contains(viewModel.selectedObjectIndex) else {
                    return
                }
                viewModel.updateObjectAngle(index: viewModel.selectedObjectIndex, newAngleInDegree: $0)
            }
        )
    }
    private var healthBinding: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                guard !viewModel.objects.isEmpty
                        && viewModel.objects.indices.contains(viewModel.selectedObjectIndex) else {
                    return 0
                }
                let health = viewModel.objects[viewModel.selectedObjectIndex].health
                return health
            },
            set: {
                guard viewModel.objects.indices.contains(viewModel.selectedObjectIndex) else {
                    return
                }
                viewModel.updateObjectHealth(index: viewModel.selectedObjectIndex, newHealth: $0)
            }
        )
    }

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Edit size")
                        .font(.headline)
                        .foregroundStyle(.black)

                    Slider(value: sizeBinding, in: 10...50)
                        .padding()
                }
                if !viewModel.objects.isEmpty && viewModel.objects.indices.contains(viewModel.selectedObjectIndex) {
                    Text("Size: \(viewModel.objects[viewModel.selectedObjectIndex].size, specifier: "%.2f")")
                        .foregroundStyle(.black)
                } else {
                    WhiteSpace()
                }
            }
            VStack {
                HStack {
                    Text("Edit orientation")
                        .font(.headline)
                        .foregroundStyle(.black)

                    Slider(value: angleBinding, in: 0...360)
                        .padding()
                }
                if !viewModel.objects.isEmpty && viewModel.objects.indices.contains(viewModel.selectedObjectIndex) {
                    Text("Radian: \(viewModel.objects[viewModel.selectedObjectIndex].angle, specifier: "%.2f")")
                        .foregroundStyle(.black)
                } else {
                    WhiteSpace()
                }
            }
            VStack {
                HStack {
                    Text("Edit health")
                        .font(.headline)
                        .foregroundStyle(.black)

                    Slider(value: healthBinding, in: 1...100)
                        .padding()
                }
                if !viewModel.objects.isEmpty && viewModel.objects.indices.contains(viewModel.selectedObjectIndex) {
                    Text("Health: \(viewModel.objects[viewModel.selectedObjectIndex].health, specifier: "%.2f")")
                        .foregroundStyle(.black)
                } else {
                    WhiteSpace()
                }
            }
        }
        .padding()
    }
}

struct ActionButtonsView: View {
    @Binding var levelName: String
    @Binding var showSaveAlert: Bool
    @Binding var showCannotOverwritePreloadedLevel: Bool
    @Binding var showOverwriteNameAlert: Bool
    @Binding var showInvalidNameAlert: Bool
    @Binding var showResetAlert: Bool
    var viewModel: LevelDesignerPaletteDelegate

    var body: some View {
        HStack {
            Button("LOAD", action: viewModel.renderLoadLevelView)
            Button("RESET") { showResetAlert = true }
            Button("SAVE") {
                if viewModel.isNameInvalid(levelName) {
                    showInvalidNameAlert = true
                } else if viewModel.isNameOverwritingPreloadedLevel(levelName) {
                    showCannotOverwritePreloadedLevel = true
                } else if viewModel.isNameOverwriting(levelName) {
                    showOverwriteNameAlert = true
                } else {
                    showSaveAlert = true
                }
            }
            TextField("Level Name", text: $levelName)
                .border(Color.black)
                .foregroundStyle(.black)
            Button("START", action: viewModel.startLevel)
        }
    }
}

struct WhiteSpace: View {
    var body: some View {
        Rectangle()
            .opacity(0)
            .frame(width: .infinity, height: 17)
    }
}

protocol LevelDesignerPaletteDelegate: AnyObject {
    var selectedObjectType: ObjectType { get }
    var isInsertMode: Bool { get }
    var selectedObjectIndex: Int { get }
    var objects: [BoardObject] { get }

    func playSound(sound: SoundType)

    // MARK: Peg management
    func selectObjectType(type: ObjectType)
    func toggleMode()

    // MARK: Edit objects
    func updateObjectSize(index: Int, newSize: CGFloat)
    func updateObjectAngle(index: Int, newAngleInDegree: CGFloat)
    func updateObjectHealth(index: Int, newHealth: CGFloat)

    // MARK: Actions
    func renderLoadLevelView()

    func isNameInvalid(_ name: String) -> Bool
    func isNameOverwriting(_ name: String) -> Bool
    func isNameOverwritingPreloadedLevel(_ name: String) -> Bool

    func saveLevel(levelName: String)

    func resetLevel()

    func startLevel()
}
