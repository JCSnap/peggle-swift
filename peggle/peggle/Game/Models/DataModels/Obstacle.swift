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
    
    init(center: CGPoint, type: ObjectType.ObstacleType, shape: ObjectShape, angle: CGFloat = .zero) {
        self.type = type
        self.shape = shape
        super.init(center: center, angle: angle)
    }
    
    convenience init(center: CGPoint, type: ObjectType.ObstacleType, angle: CGFloat = .zero) {
        let shape: ObjectShape
        switch type {
        case .rectangle:
            shape = RectangleShape()
        case .triangle:
            shape = TriangleShape()
        case .circle:
            shape = CircleShape()
        }
        self.init(center: center, type: type, shape: shape, angle: angle)
    }
    
    required init(from decoder: Decoder) throws {
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
            shape = RectangleShape()
        case String(describing: TriangleShape.self):
            shape = TriangleShape()
        case String(describing: CircleShape.self):
            shape = CircleShape()
        default:
            fatalError("Unknown shape type")
        }
        
        self.type = type
        self.shape = shape
        super.init(center: center, angle: angle)
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
    
}

class RectangleShape: ObjectShape {
    
}

class CircleShape: ObjectShape {
    
}

class TriangleShape: ObjectShape {
    
}
