//
//  BoardObject.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 23/2/24.
//

import Foundation

class BoardObject: Hashable {
    var center: CGPoint
    
    init(center: CGPoint) {
        self.center = center
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
}
