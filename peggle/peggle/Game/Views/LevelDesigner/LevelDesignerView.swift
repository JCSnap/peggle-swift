//
//  LevelDesignerView.swift
//  peggle
//  The root of the Level Designer Screen
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct LevelDesignerView: View {
    @State var levelDesignerVm: LevelDesignerVm

    var body: some View {
        ZStack {
            VStack {
                BoardView(viewModel: levelDesignerVm)

                Spacer()

                PaletteView(viewModel: levelDesignerVm)
            }
            if levelDesignerVm.isLoadLevelViewPresented {
                LoadLevelView(viewModel: levelDesignerVm)
            }
        }
        .padding()
    }
}
