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
    
    init(center: CGPoint, type: ObjectType.ObstacleType, shape: ObjectShape, size: CGFloat = Constants.rectangleObstacleSize, angle: CGFloat = .zero, health: CGFloat = Constants.defaultHealth) {
        self.type = type
        self.shape = shape
        super.init(center: center, angle: angle, health: health)
    }
    
    convenience init(center: CGPoint, type: ObjectType.ObstacleType, size: CGFloat = Constants.rectangleObstacleSize, angle: CGFloat = .zero, health: CGFloat = Constants.defaultHealth) {
        let shape: ObjectShape
        switch type {
        case .rectangle:
            shape = RectangleShape(center: center, angle: angle, width: size * Constants.rectangleWidthToHeightRatio, height: size)
        case .triangle:
            shape = TriangleShape(center: center, angle: angle)
        case .circle:
            shape = CircleShape(center: center, angle: angle)
        }
        self.init(center: center, type: type, shape: shape, angle: angle, health: health)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .centerX)
        let y = try container.decode(CGFloat.self, forKey: .centerY)
        let center = CGPoint(x: x, y: y)
        let typeString = try container.decode(String.self, forKey: .type)
            guard let type = ObjectType.ObstacleType(stringValue: typeString) else {
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid obstacle type")
            }
        let angle = try container.decode(CGFloat.self, forKey: .angle)
        let health = try container.decode(CGFloat.self, forKey: .health)
        
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
        
        self.init(center: center, type: type, shape: shape, angle: angle, health: health)
    }
    
    override func isInBoundary(within size: CGSize) -> Bool {
        shape.isInBoundary(within: size)
    }
    
    override func overlaps<T: BoardObject>(with other: T) -> Bool {
        if let peg = other as? Peg {
            return shape.overlaps(with: peg)
        } else if let obstacle = other as? Obstacle {
            return shape.overlaps(with: obstacle.shape)
        } else {
            return false
        }
    }
    
    override func updateSize(to newSize: CGFloat) {
        self.shape.updateSize(to: newSize)
    }
    
    override func updateAngle(to newAngle: CGFloat) {
        self.angle = newAngle
        self.shape.angle = newAngle
    }
}

extension Obstacle: Codable {
    enum CodingKeys: String, CodingKey {
        case centerX = "center_x"
        case centerY = "center_y"
        case type
        case shapeType
        case angle
        case size
        case health
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center.x, forKey: .centerX)
        try container.encode(center.y, forKey: .centerY)
        try container.encode(type.stringValue, forKey: .type)
        
        try container.encode(angle, forKey: .angle)
        try container.encode(size, forKey: .size)
        try container.encode(health, forKey: .health)
        
        let shapeType = String(describing: Swift.type(of: shape))
        try container.encode(shapeType, forKey: .shapeType)
    }

}
