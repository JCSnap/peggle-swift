//
//  Obstacle.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 27/2/24.
//

import Foundation

class Obstacle: BoardObject {
    var shape: ObjectShape
    var type: ObjectType.ObstacleType
    override var size: CGFloat {
        shape.size
    }
    
    init(center: CGPoint, type: ObjectType.ObstacleType, shape: ObjectShape, angle: CGFloat = .zero) {
        self.type = type
        self.shape = shape
        super.init(center: center, angle: angle)
    }
    
    convenience init(center: CGPoint, type: ObjectType.ObstacleType, angle: CGFloat = .zero) {
        let shape: ObjectShape
        switch type {
        case .rectangle:
            shape = RectangleShape(center: center, angle: angle, width: Constants.rectangleObstacleSize * 5, height: Constants.rectangleObstacleSize)
        case .triangle:
            shape = TriangleShape(center: center, angle: angle)
        case .circle:
            shape = CircleShape(center: center, angle: angle)
        }
        self.init(center: center, type: type, shape: shape, angle: angle)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .centerX)
        let y = try container.decode(CGFloat.self, forKey: .centerY)
        let center = CGPoint(x: x, y: y)
        let type = try container.decode(ObjectType.ObstacleType.self, forKey: .type)
        let angle = try container.decode(CGFloat.self, forKey: .angle)
        
        let shapeType = try container.decode(String.self, forKey: .shapeType)
        let shape: ObjectShape
        switch shapeType {
        case String(describing: RectangleShape.self):
            shape = try RectangleShape(from: decoder)
        case String(describing: TriangleShape.self):
            shape = try TriangleShape(from: decoder)
        case String(describing: CircleShape.self):
            shape = try CircleShape(from: decoder)
        default:
            shape = try RectangleShape(from: decoder)
        }
        
        self.init(center: center, type: type, shape: shape, angle: angle)
    }
    
    override func isInBoundary(within size: CGSize) -> Bool {
        shape.isInBoundary(within: size)
    }
    
    override func overlaps<T: BoardObject>(with other: T) -> Bool {
        if let peg = other as? Peg {
            return false
        } else if let obstacle = other as? Obstacle {
            return false
        } else {
            return false
        }
    }
    
    override func updateSize(to newSize: CGFloat) {
        self.shape.updateSize(to: newSize)
    }
}

extension Obstacle: Codable {
    enum CodingKeys: String, CodingKey {
        case centerX = "center_x"
        case centerY = "center_y"
        case type
        case shapeType
        case angle
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center.x, forKey: .centerX)
        try container.encode(center.y, forKey: .centerY)
        try container.encode(type, forKey: .type)
        try container.encode(angle, forKey: .angle)
        
        let shapeType = String(describing: Swift.type(of: shape))
        try container.encode(shapeType, forKey: .shapeType)
    }
}



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
}

class RectangleShape: ObjectShape {
    var width: CGFloat
    var height: CGFloat
    
    override var size: CGFloat {
        width / 5
    }
    
    init(center: CGPoint, angle: CGFloat, width: CGFloat = Constants.rectangleObstacleSize * 5, height: CGFloat = Constants.rectangleObstacleSize) {
        self.width = width
        self.height = height
        super.init(center: center, angle: angle)
    }
    
    required init(center: CGPoint, angle: CGFloat) {
        fatalError("init(center:) has not been implemented")
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func isInBoundary(within size: CGSize) -> Bool {
        let halfWidth = width / 2
        let halfHeight = height / 2
        let corners = [
            CGPoint(x: -halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: -halfHeight),
            CGPoint(x: -halfWidth, y: halfHeight),
            CGPoint(x: halfWidth, y: halfHeight)
        ]
        
        let rotatedCorners = corners.map { corner -> CGPoint in
            let rotatedX = corner.x * cos(angle) - corner.y * sin(angle)
            let rotatedY = corner.x * sin(angle) + corner.y * cos(angle)
            return CGPoint(x: center.x + rotatedX, y: center.y + rotatedY)
        }
        
        return rotatedCorners.allSatisfy { corner in
            corner.x >= 0 && corner.x <= size.width && corner.y >= 0 && corner.y <= size.height
        }
    }
    
    override func updateSize(to newSize: CGFloat) {
        self.width = 5 * newSize
    }
}

class CircleShape: ObjectShape {
    
}

class TriangleShape: ObjectShape {
    
}
