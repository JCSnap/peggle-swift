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
    let orientation: Angle
    
    init(pegType: PegType, radius: CGFloat = Constants.defaultAssetRadius, isGlowing: Bool, orientation: Angle = .zero) {
        self.pegType = pegType
        self.radius = radius
        self.isGlowing = isGlowing
        self.orientation = orientation
    }

    var body: some View {
        Image(pegImage)
            .resizable()
            .scaledToFit()
            .frame(width: radius * 2, height: radius * 2)
            .clipShape(Circle())
            .contentShape(Circle())
            .rotationEffect(orientation)
    }

    private var pegImage: String {
        let imageNames: [PegType: String] = [
            .normal: isGlowing ? "peg-blue-glow" : "peg-blue",
            .scoring: isGlowing ? "peg-orange-glow" : "peg-orange",
            .exploding: isGlowing ? "peg-green-glow" : "peg-green"
        ]
        return imageNames[pegType] ?? "default-peg-image"
    }
}
