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
    @State private var showResetAlert = false

    var body: some View {
        let resetAlertText = "Are you sure you want to reset? This action cannot be reversed"
        let saveAlertText = "Save level with: \(levelName)?"
        let invalidNameAlertText = "Invalid Level Name"
        let invalidNameAlertMessage =
        """
        Please use a valid name that does not contain unsavable characters,
        consist only of whitespace, or more than 30 characters.
        """

        VStack {
            PegSelectionView(viewModel: viewModel)
            ActionButtonsView(levelName: $levelName, showSaveAlert: $showSaveAlert,
                              showInvalidNameAlert: $showInvalidNameAlert,
                              showResetAlert: $showResetAlert, viewModel: viewModel)
            .alert(resetAlertText, isPresented: $showResetAlert) {
                Button("CANCEL", role: .cancel) { }
                Button("YES") { viewModel.resetLevel() }
            }
            .alert(saveAlertText, isPresented: $showSaveAlert) {
                Button("CANCEL", role: .cancel) { }
                Button("OK") { viewModel.saveLevel(levelName: levelName) }
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

    var body: some View {
        HStack {
            Button(action: {
                viewModel.selectPegType(type: .normal)
            }) {
                PegView(pegType: .normal, isGlowing: false)
                    .border(viewModel.selectedPegType == .normal ? Color.blue : Color.clear, width: 3)
            }
            Button(action: {
                viewModel.selectPegType(type: .scoring)
            }) {
                PegView(pegType: .scoring, isGlowing: false)
                    .border(viewModel.selectedPegType == .scoring ? Color.orange : Color.clear, width: 3)
            }
            Button(action: {
                viewModel.selectPegType(type: .exploding)
            }) {
                PegView(pegType: .exploding, isGlowing: false)
                    .border(viewModel.selectedPegType == .exploding ? Color.green : Color.clear, width: 3)
            }
            Spacer()
            Button(action: viewModel.toggleMode) {
                DeleteButtonView()
                    .background(viewModel.isInsertMode ? Color.clear : Color.red.opacity(0.3))
                    .cornerRadius(5)
            }
        }
    }
}

struct ActionButtonsView: View {
    @Binding var levelName: String
    @Binding var showSaveAlert: Bool
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

protocol LevelDesignerPaletteDelegate: AnyObject {
    var selectedPegType: PegType { get }
    var isInsertMode: Bool { get }

    // MARK: Peg management
    func selectPegType(type: PegType)
    func toggleMode()

    // MARK: Actions
    func renderLoadLevelView()

    func isNameInvalid(_ name: String) -> Bool

    func saveLevel(levelName: String)

    func resetLevel()

    func startLevel()
}
