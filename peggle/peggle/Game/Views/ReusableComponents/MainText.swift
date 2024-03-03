//
//  Text.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 2/3/24.
//

import SwiftUI

struct MainText: View {
    var text: String
    var size: CGFloat
    var color: any ShapeStyle

    var body: some View {
        Text("\(text)")
            .font(.custom("Marker Felt", size: size))
            .foregroundStyle(color)
    }
}
