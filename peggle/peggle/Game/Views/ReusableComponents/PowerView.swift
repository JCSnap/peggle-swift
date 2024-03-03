//
//  PowerView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 26/2/24.
//

import SwiftUI

struct PowerView: View {
    let powerType: PowerType
    let size = CGSize(width: 100, height: 100)

    var body: some View {
        Image(powerImage)
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height)
    }

    private var powerImage: String {
        let imageNames: [PowerType: String] = [
            .exploding: "explosion-power",
            .spookyBall: "spooky-ball-power",
            .reverseGravity: "reverse-gravity-power",
            .poop: "poop-power"
        ]
        return imageNames[powerType] ?? "explosion-power"
    }
}

#Preview {
    PowerView(powerType: .exploding)
}
