//
//  BucketView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 21/2/24.
//

import SwiftUI

struct BucketView: View {
    var body: some View {
        Image("bucket")
            .resizable()
            .scaledToFit()
            .frame(width: Constants.defaultBucketSize.width, height: Constants.defaultBucketSize.height)
    }
}

#Preview {
    BucketView()
}
