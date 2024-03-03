//
//  Bucket.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 21/2/24.
//

import Foundation

struct Bucket {
    var center: CGPoint
    var width: CGFloat
    var height: CGFloat

    init(center: CGPoint, width: CGFloat = Constants.defaultBucketSize.width,
         height: CGFloat = Constants.defaultBucketSize.height) {
        self.center = center
        self.width = width
        self.height = height
    }
}
