//
//  CGExtensions.swift
//  physics-engine
//
//  Created by Justin Cheah Yun Fei on 6/2/24.
//

import Foundation
import CoreGraphics

struct CGExtensions {
}

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    var magnitude: CGFloat {
        sqrt(x * x + y * y)
    }
    
    var normalized: CGPoint {
        let length = sqrt(self.x * self.x + self.y * self.y)
        guard length != 0 else { return CGPoint(x: 0, y: 0) }
        return CGPoint(x: self.x / length, y: self.y / length)
    }

    static func + (point: CGPoint, vector: CGVector) -> CGPoint {
        CGPoint(x: point.x + vector.dx, y: point.y + vector.dy)
    }

    static func += (point: inout CGPoint, vector: CGVector) {
        point = point + vector
    }

    static func - (point: CGPoint, vector: CGVector) -> CGPoint {
        CGPoint(x: point.x - vector.dx, y: point.y - vector.dy)
    }

    static func -= (point: inout CGPoint, vector: CGVector) {
        point = point - vector
    }
}

extension CGPoint {
    func isAlmostEqual(to point: CGPoint, epsilon: CGFloat = 1e-5) -> Bool {
        abs(self.x - point.x) < epsilon && abs(self.y - point.y) < epsilon
    }
}

extension CGVector {
    var normalized: CGVector {
        let length = self.magnitude
        return length > 0 ? CGVector(dx: dx / length, dy: dy / length) : CGVector(dx: 0, dy: 0)
    }

    var magnitude: CGFloat {
        sqrt(dx * dx + dy * dy)
    }

    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func += (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func -= (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs - rhs
    }

    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    func dotProduct(with other: CGVector) -> CGFloat {
        dx * other.dx + dy * other.dy
    }
}
