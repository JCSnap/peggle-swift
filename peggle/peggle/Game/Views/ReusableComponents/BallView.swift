//
//  BallView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 18/2/24.
//

import SwiftUI

struct BallView: View {
    let radius: CGFloat
    var ballType: BallType
    
    init(radius: CGFloat = Constants.defaultAssetRadius, ballType: BallType) {
        self.radius = radius
        self.ballType = ballType
    }
    
    var body: some View {
        Image(ballImage)
            .resizable()
            .scaledToFit()
            .frame(width: radius * 2, height: radius * 2)
    }
    
    private var ballImage: String {
        let imageNames: [BallType: String] = [
            .normal: "ball",
            .poop: "poop-power"
        ]
        return imageNames[ballType] ?? "ball"
    }
}

#Preview {
    BallView(ballType: .normal)
}
