//
//  RectangleObstacleView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 27/2/24.
//

import SwiftUI

struct ObstacleView: View {
    var type: ObjectType.ObstacleType
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Image("rectangle-obstacle")
            .resizable()
            .frame(width: width, height: height)
    }
    
    private var pegImage: String {
        let imageNames: [ObjectType.ObstacleType: String] = [
            .rectangle: "rectangle-obstacle",
            .triangle: "rectangle-obstacle",
            .circle: "rectangle-obstacle",
        ]
        return imageNames[type] ?? "rectangle-obstacle"
    }
}
