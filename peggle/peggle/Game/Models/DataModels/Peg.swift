//
//  Peg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import Foundation

enum PegType: Codable {
    case normal, scoring
}

class Peg: BoardObject {
    var type: PegType
    var radius: CGFloat
    var isGlowing = false

    init(center: CGPoint, type: PegType, radius: CGFloat = Constants.defaultAssetRadius) {
        self.type = type
        self.radius = radius
        super.init(center: center)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .centerX)
        let y = try container.decode(CGFloat.self, forKey: .centerY)
        let center = CGPoint(x: x, y: y)
        let type = try container.decode(PegType.self, forKey: .type)
        let radius = try container.decode(CGFloat.self, forKey: .radius)
        self.init(center: center, type: type, radius: radius)
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
    
    override func isEqual<T: BoardObject>(to other: T) -> Bool {
        guard Swift.type(of: self) == Swift.type(of: other) else {
            return false
        }
        return self.center == other.center
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
        case type
        case radius
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center.x, forKey: .centerX)
        try container.encode(center.y, forKey: .centerY)
        try container.encode(type, forKey: .type)
        try container.encode(radius, forKey: .radius)
    }
}

// MARK: Helpers
extension Peg {
    private func distance(from point: CGPoint) -> CGFloat {
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt(dx * dx + dy * dy)
    }
}

