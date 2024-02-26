//
//  BoardObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/2/24.
//

import Foundation

class BoardObject: Hashable {
    var center: CGPoint
    var angle: CGFloat
    
    init(center: CGPoint, angle: CGFloat = .zero) {
        self.center = center
        self.angle = angle
    }
    func overlaps<T: BoardObject>(with other: T) -> Bool {
        fatalError("Subclasses need to implement this method")
    }
    
    func isInBoundary(within size: CGSize) -> Bool {
        fatalError("Subclasses need to implement this method")
    }
    
    func isEqual<T: BoardObject>(to other: T) -> Bool {
        fatalError("Subclasses need to implement this method")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(center)
    }
    
    static func ==(lhs: BoardObject, rhs: BoardObject) -> Bool {
        return lhs.center == rhs.center
    }
    
    func addToBoard(board: inout Board) {
        fatalError("Subclasses need to implement this method")
    }
    
    func updateSize(to newSize: CGFloat) {
        fatalError("Subclasses need to implement this method")
    }
    
    func updateAngle(to newAngle: CGFloat) {
        self.angle = newAngle
    }
}
