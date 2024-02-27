//
//  RectangleObstacleView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 27/2/24.
//

import SwiftUI

struct ObstacleView: View {
    var type: ObjectType.ObstacleType
    var size: CGFloat
    var angle: CGFloat = .zero
    
    var body: some View {
        Image("rectangle-obstacle")
            .resizable()
            .frame(width: frameWidth * size, height: frameHeight * size)
            .rotationEffect(.radians(angle))
    }
    
    private var pegImage: String {
        let imageNames: [ObjectType.ObstacleType: String] = [
            .rectangle: "rectangle-obstacle",
            .triangle: "rectangle-obstacle",
            .circle: "rectangle-obstacle",
        ]
        return imageNames[type] ?? "rectangle-obstacle"
    }
    
    private let frameDimensions: [ObjectType.ObstacleType: (widthMultiplier: CGFloat, heightMultiplier: CGFloat)] = [
        .rectangle: (widthMultiplier: 5, heightMultiplier: 1),
        .triangle: (widthMultiplier: 5, heightMultiplier: 1),
        .circle: (widthMultiplier: 2, heightMultiplier: 2)
    ]
    
    private var frameWidth: CGFloat {
        frameDimensions[type]?.widthMultiplier ?? 1 * size
    }
    
    private var frameHeight: CGFloat {
        frameDimensions[type]?.heightMultiplier ?? 1 * size
    }
}
