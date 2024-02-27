//
//  Peg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import Foundation

class Peg: BoardObject {
    var type: ObjectType.PegType
    var radius: CGFloat
    var isGlowing: Bool = false
    override var size: CGFloat {
        radius
    }

    init(center: CGPoint, type: ObjectType.PegType, radius: CGFloat = Constants.defaultAssetRadius, angle: CGFloat = .zero) {
        self.type = type
        self.radius = radius
        super.init(center: center, angle: angle)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .centerX)
        let y = try container.decode(CGFloat.self, forKey: .centerY)
        let center = CGPoint(x: x, y: y)
        let type = try container.decode(ObjectType.PegType.self, forKey: .pegType)
        let radius = try container.decode(CGFloat.self, forKey: .radius)
        let angle = try container.decode(CGFloat.self, forKey: .angle)
        self.init(center: center, type: type, radius: radius, angle: angle)
    }
    
    
    func glowUp() {
        isGlowing = true
    }
    
    func isPointInPeg(point: CGPoint) -> Bool {
        distance(from: point) <= radius
    }

    override func overlaps<T: BoardObject>(with other: T) -> Bool {
        if let peg = other as? Peg {
            return distance(from: peg.center) <= self.radius + peg.radius
        } else if let obstacle = other as? Obstacle {
            return obstacle.shape.overlaps(with: self)
        } else {
            return false
        }
    }

    override func isInBoundary(within size: CGSize) -> Bool {
        center.x - radius >= 0 &&    // Left
        center.x + self.radius <= size.width &&  // Right
        center.y - self.radius >= 0 &&           // Bottom
        center.y + self.radius <= size.height    // Top
    }
    
    override func updateSize(to newSize: CGFloat) {
        self.radius = newSize
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(center.x)
        hasher.combine(center.y)
        hasher.combine(type)
        hasher.combine(radius)
    }
}

extension Peg {
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.center == rhs.center &&
        lhs.type == rhs.type &&
        lhs.radius == rhs.radius
    }
}

// MARK: Codable
extension Peg: Codable {
    enum CodingKeys: String, CodingKey {
        case centerX = "center_x"
        case centerY = "center_y"
        case pegType
        case radius
        case angle
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center.x, forKey: .centerX)
        try container.encode(center.y, forKey: .centerY)
        try container.encode(type, forKey: .pegType)
        try container.encode(radius, forKey: .radius)
        try container.encode(angle, forKey: .angle)
    }
}

// MARK: Utils
extension Peg {
    func distance(from point: CGPoint) -> CGFloat {
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt(dx * dx + dy * dy)
    }
}

