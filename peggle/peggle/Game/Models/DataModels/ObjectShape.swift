//
//  ObjectShape.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 27/2/24.
//

import Foundation

class ObjectShape: Codable {
    var center: CGPoint
    var angle: CGFloat
    var size: CGFloat {
        .zero
    }
    
    required init(center: CGPoint, angle: CGFloat) {
        self.center = center
        self.angle = angle
    }
    
    func isInBoundary(within size: CGSize) -> Bool {
        fatalError("Subclasses should implement this method")
    }
    
    func updateSize(to newSize: CGFloat) {
        fatalError("Subclasses should implement this method")
    }
    
    func overlaps(with peg: Peg) -> Bool {
        fatalError("Subclasses should implement this method")
    }
    
    func overlaps(with rectangle: RectangleShape) -> Bool {
        fatalError("Subclasses should implement this method")
    }
    
    func overlaps(with circle: CircleShape) -> Bool {
        fatalError("Subclasses should implement this method")
    }
    
    func overlaps(with triangle: TriangleShape) -> Bool {
        fatalError("Subclasses should implement this method")
    }
}

class RectangleShape: ObjectShape {
    var width: CGFloat
    var height: CGFloat
    
    override var size: CGFloat {
        width / Constants.rectangleWidthToHeightRatio
    }
    var corners: [CGPoint] {
        let halfWidth = width / 2
        let halfHeight = height / 2
        return [
            CGPoint(x: center.x - halfWidth, y: center.y - halfHeight),
            CGPoint(x: center.x + halfWidth, y: center.y - halfHeight),
            CGPoint(x: center.x - halfWidth, y: center.y + halfHeight),
            CGPoint(x: center.x + halfWidth, y: center.y + halfHeight)
        ].map { corner in
            let translatedX = corner.x - center.x
            let translatedY = corner.y - center.y
            let rotatedX = translatedX * cos(angle) - translatedY * sin(angle)
            let rotatedY = translatedX * sin(angle) + translatedY * cos(angle)
            return CGPoint(x: center.x + rotatedX, y: center.y + rotatedY)
        }
    }
    
    init(center: CGPoint, angle: CGFloat, width: CGFloat = Constants.rectangleObstacleSize * Constants.rectangleWidthToHeightRatio, height: CGFloat = Constants.rectangleObstacleSize) {
        self.width = width
        self.height = height
        super.init(center: center, angle: angle)
    }
    
    func contains(point: CGPoint) -> Bool {
        let translatedX = point.x - center.x
        let translatedY = point.y - center.y
        let rotatedX = translatedX * cos(-angle) - translatedY * sin(-angle)
        let rotatedY = translatedX * sin(-angle) + translatedY * cos(-angle)
        return abs(rotatedX) <= width / 2 && abs(rotatedY) <= height / 2
    }
    
    override func overlaps(with peg: Peg) -> Bool {
        let cosAngle = cos(-angle)
        let sinAngle = sin(-angle)
        let translatedX = peg.center.x - center.x
        let translatedY = peg.center.y - center.y
        let rotatedPegX = translatedX * cosAngle - translatedY * sinAngle + center.x
        let rotatedPegY = translatedX * sinAngle + translatedY * cosAngle + center.y
        let rotatedPegCenter = CGPoint(x: rotatedPegX, y: rotatedPegY)
        
        let closestX = max(center.x - width / 2, min(rotatedPegCenter.x, center.x + width / 2))
        let closestY = max(center.y - height / 2, min(rotatedPegCenter.y, center.y + height / 2))
        
        let closestPointRotatedBackX = (closestX - center.x) * cosAngle + (closestY - center.y) * sinAngle + center.x
        let closestPointRotatedBackY = -(closestX - center.x) * sinAngle + (closestY - center.y) * cosAngle + center.y
        
        let distanceX = peg.center.x - closestPointRotatedBackX
        let distanceY = peg.center.y - closestPointRotatedBackY
        
        return sqrt(distanceX * distanceX + distanceY * distanceY) < peg.radius
    }

    required init(center: CGPoint, angle: CGFloat) {
        self.width = Constants.rectangleObstacleSize * Constants.rectangleWidthToHeightRatio
        self.height = Constants.rectangleObstacleSize
        super.init(center: center, angle: angle)
    }
    
    enum CodingKeys: String, CodingKey {
        case centerX = "center_x"
        case centerY = "center_y"
        case angle
        case size
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .centerX)
        let y = try container.decode(CGFloat.self, forKey: .centerY)
        let center = CGPoint(x: x, y: y)
        let angle = try container.decode(CGFloat.self, forKey: .angle)
        let size = try container.decode(CGFloat.self, forKey: .size)
        self.width = size * Constants.rectangleWidthToHeightRatio
        self.height = size
        super.init(center: center, angle: angle)
    }
    
    override func isInBoundary(within size: CGSize) -> Bool {
        let halfWidth = width / 2
        let halfHeight = height / 2
        
        return corners.allSatisfy { corner in
            corner.x >= 0 && corner.x <= size.width && corner.y >= 0 && corner.y <= size.height
        }
    }
    
    override func updateSize(to newSize: CGFloat) {
        self.width = Constants.rectangleWidthToHeightRatio * newSize
        self.height = newSize
    }
}

class CircleShape: ObjectShape {
    var radius: CGFloat
    override var size: CGFloat {
        radius
    }
    
    init(center: CGPoint, radius: CGFloat, angle: CGFloat) {
        self.radius = radius
        super.init(center: center, angle: angle)
    }
    
    required init(center: CGPoint, angle: CGFloat) {
        self.radius = Constants.defaultAssetRadius
        super.init(center: center, angle: angle)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class TriangleShape: ObjectShape {
    
}

