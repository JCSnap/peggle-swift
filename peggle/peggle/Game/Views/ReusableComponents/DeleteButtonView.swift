//
//  DeleteButtonView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import SwiftUI

struct DeleteButtonView: View {
    let radius: CGFloat
    let deleteButtonImage = "delete"

    init(radius: CGFloat = Constants.defaultAssetRadius) {
        self.radius = radius
    }

    var body: some View {
        Image(deleteButtonImage)
            .resizable()
            .scaledToFit()
            .frame(width: radius * 2, height: radius * 2)
    }
}

#Preview {
    DeleteButtonView()
}
