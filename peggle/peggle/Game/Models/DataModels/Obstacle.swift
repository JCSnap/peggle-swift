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
            shape = RectangleShape(center: center, width: Constants.paletteRectangleObstacleWidth, height: Constants.paletteRectangleObstacleHeight)
        case .triangle:
            shape = TriangleShape(center: center)
        case .circle:
            shape = CircleShape(center: center)
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
    var size: CGFloat {
        .zero
    }
    
    required init(center: CGPoint) {
        self.center = center
    }
    
    func isInBoundary(within size: CGSize) -> Bool {
        fatalError("Subclasses should implement this method")
    }
}

class RectangleShape: ObjectShape {
    var width: CGFloat
    var height: CGFloat
    
    override var size: CGFloat {
        0.5 * width + 0.5 * height
    }
    
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        super.init(center: center)
    }
    
    required init(center: CGPoint) {
        fatalError("init(center:) has not been implemented")
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func isInBoundary(within size: CGSize) -> Bool {
        let leftEdge = center.x - width / 2
        let rightEdge = center.x + width / 2
        let topEdge = center.y - height / 2
        let bottomEdge = center.y + height / 2
        
        return leftEdge >= 0 && rightEdge <= size.width && topEdge >= 0 && bottomEdge <= size.height
    }
}

class CircleShape: ObjectShape {
    
}

class TriangleShape: ObjectShape {
    
}
