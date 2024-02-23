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
        let imageNames: [PegType: String] = [
            .blue: isGlowing ? "peg-blue-glow" : "peg-blue",
            .orange: isGlowing ? "peg-orange-glow" : "peg-orange"
        ]
        return imageNames[pegType] ?? "default-peg-image"
    }
}

#Preview {
    PegView(pegType: .blue, isGlowing: true)
}
