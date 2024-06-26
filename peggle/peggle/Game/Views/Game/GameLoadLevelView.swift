//
//  GameLoadLevelView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 14/2/24.
//

import SwiftUI

struct GameLoadLevelView: View {
    var viewModel: GameLoadLevelViewDelegate
    var boundsSize: CGSize = Constants.defaultBounds.size
    @State private var showGoToLevelDesignerAlert = false

    var body: some View {
        VStack {
            MainText(text: "Load Level", size: 30, color: .black)
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.getNamesOfAvailableLevels(), id: \.self) { levelName in
                        LevelView(viewModel: viewModel, levelName: levelName)
                    }
                }
                .padding()
            }
            .frame(width: 400, height: 500)
        }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .onAppear {
                viewModel.createAndSavePreloadedLevelsToPersistence(boundsSize: boundsSize)
                showGoToLevelDesignerAlert = viewModel.getNamesOfAvailableLevels().isEmpty
            }
            .alert("No level to load, go to level designer?", isPresented: $showGoToLevelDesignerAlert) {
                Button("YES") { viewModel.goToLevelDesignerView() }
            }
    }
}

struct LevelView: View {
    var viewModel: GameLoadLevelViewDelegate
    var levelName: String

    var body: some View {
        Button(action: {
            viewModel.setLevelFromPersistenceAndRenderGame(levelName: levelName)
        }) {
            Text(levelName)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
        }
    }
}

protocol GameLoadLevelViewDelegate: AnyObject {
    func getNamesOfAvailableLevels() -> [String]
    func setLevelFromPersistenceAndRenderGame(levelName: String)
    func createAndSavePreloadedLevelsToPersistence(boundsSize: CGSize)

    func goToLevelDesignerView()
}
