//
//  Peg.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/1/24.
//

import Foundation

enum PegType: Codable {
    case blue, orange

    var description: String {
        switch self {
        case .blue:
            return "Blue Peg"
        case .orange:
            return "Orange Peg"
        }
    }
}

struct Peg: Hashable {
    var center: CGPoint
    let type: PegType
    let radius: CGFloat
    var isGlowing = false

    init(center: CGPoint, type: PegType, radius: CGFloat = Constants.defaultAssetRadius) {
        self.center = center
        self.type = type
        self.radius = radius
    }

    mutating func glowUp() {
        isGlowing = true
    }
}

extension Peg: Equatable {
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.center == rhs.center &&
        lhs.type == rhs.type &&
        lhs.radius == rhs.radius
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(center.x)
        hasher.combine(center.y)
        hasher.combine(type)
        hasher.combine(radius)
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .centerX)
        let y = try container.decode(CGFloat.self, forKey: .centerY)
        center = CGPoint(x: x, y: y)
        type = try container.decode(PegType.self, forKey: .type)
        radius = try container.decode(CGFloat.self, forKey: .radius)
    }
}

// MARK: Utils
extension Peg {
    func isPointInPeg(point: CGPoint) -> Bool {
        distance(from: point) <= radius
    }

    func overlaps(with other: Peg) -> Bool {
        distance(from: other.center) <= self.radius + other.radius
    }

    func isInBoundary(within size: CGSize) -> Bool {
        center.x - radius >= 0 &&    // Left
        center.x + self.radius <= size.width &&  // Right
        center.y - self.radius >= 0 &&           // Bottom
        center.y + self.radius <= size.height    // Top
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
