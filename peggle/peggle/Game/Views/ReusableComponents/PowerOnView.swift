//
//  PowerOnView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/2/24.
//

import SwiftUI

struct PowerOnView: View {
    var body: some View {
        Image("green-star")
            .resizable()
            .scaledToFit()
            .frame(width: 90, height: 90)
    }
}

#Preview {
    PowerOnView()
}
