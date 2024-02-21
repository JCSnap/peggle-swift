//
//  PegView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct PegView: View {
    let pegType: PegType
    let radius: CGFloat
    let isGlowing: Bool

    init(pegType: PegType, isGlowing: Bool, radius: CGFloat = Constants.defaultAssetRadius) {
        self.pegType = pegType
        self.radius = radius
        self.isGlowing = isGlowing
    }

    var body: some View {
        Image(pegImage)
            .resizable()
            .scaledToFit()
            .frame(width: radius * 2, height: radius * 2)
    }

    private var pegImage: String {
        switch pegType {
        case .blue:
            return isGlowing ? "peg-blue-glow" : "peg-blue"
        case .orange:
            return isGlowing ? "peg-orange-glow" : "peg-orange"
        }
    }
}

#Preview {
    PegView(pegType: .blue, isGlowing: true)
}
