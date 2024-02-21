//
//  BallView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 18/2/24.
//

import SwiftUI

struct BallView: View {
    let radius: CGFloat

    init() {
        self.radius = Constants.defaultAssetRadius
    }

    var body: some View {
        Image("ball")
            .resizable()
            .scaledToFit()
            .frame(width: radius * 2, height: radius * 2)
    }
}

#Preview {
    BallView()
}
