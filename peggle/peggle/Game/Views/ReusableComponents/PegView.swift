//
//  PegView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct PegView: View {
    let pegType: ObjectType.PegType
    let radius: CGFloat
    let isGlowing: Bool
    let angle: Angle

    init(pegType: ObjectType.PegType, radius: CGFloat = Constants.defaultAssetRadius, isGlowing: Bool, angle: Angle = .zero) {
        self.pegType = pegType
        self.radius = radius
        self.isGlowing = isGlowing
        self.angle = angle
    }

    var body: some View {
        Image(pegImage)
            .resizable()
            .scaledToFit()
            .frame(width: radius * 2, height: radius * 2)
            .clipShape(Circle())
            .contentShape(Circle())
            .rotationEffect(angle)
    }

    private var pegImage: String {
        let imageNames: [ObjectType.PegType: String] = [
            .normal: isGlowing ? "peg-blue-glow" : "peg-blue",
            .scoring: isGlowing ? "peg-orange-glow" : "peg-orange",
            .exploding: isGlowing ? "peg-green-glow" : "peg-green",
            .stubborn: isGlowing ? "peg-red-glow" : "peg-red"
        ]
        return imageNames[pegType] ?? "default-peg-image"
    }
}
