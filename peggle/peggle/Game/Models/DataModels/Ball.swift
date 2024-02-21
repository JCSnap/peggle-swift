//
//  Ball.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 7/2/24.
//

import Foundation

struct Ball {
    var center: CGPoint
    let radius: CGFloat

    init(center: CGPoint, radius: CGFloat = Constants.defaultAssetRadius) {
        self.center = center
        self.radius = radius
    }
}
