//
//  LoadLevelView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 25/1/24.
//

import SwiftUI

struct LoadLevelView: View {
    var viewModel: LevelDesignerLoadLevelDelegate
    @State private var showDeleteAlert = false
    @State private var selectedLevelNameToDelete = ""

    var body: some View {
        let deleteLevelText = "Are you sure you want to delete \(selectedLevelNameToDelete)"
        
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Close the modal when the background is tapped
                    viewModel.toggleLoadLevelView()
                }
            VStack {
                Text("Load Level").font(.title).bold().foregroundStyle(.black)
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.getNamesOfAvailableLevels(), id: \.self) { levelName in
                            HStack {
                                Button(action: {
                                    viewModel.loadLevel(withName: levelName)
                                    viewModel.toggleLoadLevelView()
                                }) {
                                    Text(levelName)
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                }
                                Button(action: {
                                    self.selectedLevelNameToDelete = levelName
                                    self.showDeleteAlert = true
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            }
                        }
                    }
                    .padding()
                    .alert(deleteLevelText, isPresented: $showDeleteAlert) {
                        Button("CANCEL", role: .cancel) { }
                        Button("YES") { viewModel.deleteLevel(selectedLevelNameToDelete) }
                    }
                }
                .frame(width: 400, height: 500)
            }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
        }
    }
}

protocol LevelDesignerLoadLevelDelegate: AnyObject {
    var isLoadLevelViewPresented: Bool { get }

    func loadLevel(withName name: String)

    func getNamesOfAvailableLevels() -> [String]
    
    func deleteLevel(_ levelName: String)

    func toggleLoadLevelView()
}
