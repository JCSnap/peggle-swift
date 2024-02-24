//
//  Board.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 2/2/24.
//

import Foundation

struct Board {
    var objects: [BoardObject] = []
    var boardSize: CGSize = .zero
    
    init(withSize boardSize: CGSize = CGSize()) {
        self.boardSize = boardSize
    }
    
    mutating func addPeg(at point: CGPoint, withType type: PegType,
                         withSize size: CGFloat = Constants.defaultAssetRadius) {
        let newPeg = Peg(center: CGPoint(x: point.x, y: point.y), type: type, radius: size)
        if !isOverlapping(newPeg) && isWithinBoard(newPeg) {
            objects.append(newPeg)
        }
    }
    
    mutating func deleteBoardObject(_ object: BoardObject) {
        objects.removeAll { $0.isEqual(to: object) }
    }
    
    mutating func updatePegPosition(index: Int, newPoint: CGPoint) {
        if index >= objects.count {
            return
        }
        var object = objects[index]
        object.center = newPoint
        if isWithinBoard(object) && !isOverlapping(object, excludingIndex: index) {
            objects[index] = object
        }
    }
    
    mutating func setBoardSize(_ size: CGSize) {
        boardSize = size
    }
}

extension Board: Hashable & Codable {
    static func == (lhs: Board, rhs: Board) -> Bool {
        lhs.objects == rhs.objects
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(objects)
    }
    
    enum BoardObjectType: String, Codable {
        case peg = "Peg"
    }
    
    private enum CodingKeys: String, CodingKey {
        case objects, boardSize
    }
    
    private enum ObjectTypeKey: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objectsArrayForType = try container.nestedUnkeyedContainer(forKey: .objects)
        var objects = [BoardObject]()
        
        var objectsArray = objectsArrayForType
        while !objectsArray.isAtEnd {
            let objectContainer = try objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)
            let type = try objectContainer.decode(BoardObjectType.self, forKey: .type)
            
            switch type {
            case .peg:
                let peg = try objectsArray.decode(Peg.self)
                objects.append(peg)
            }
        }
        self.objects = objects
        self.boardSize = try container.decode(CGSize.self, forKey: .boardSize)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boardSize, forKey: .boardSize)
        
        var objectsArray = container.nestedUnkeyedContainer(forKey: .objects)
        for object in objects {
            var objectContainer = objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)
            if let peg = object as? Peg {
                try objectContainer.encode(BoardObjectType.peg, forKey: .type)
                try objectsArray.encode(peg)
            }
            else {
                fatalError("Unknown BoardObject subclass")
            }
        }
    }
}

// MARK: helpers
extension Board {
    internal func isOverlapping(_ peg: BoardObject, excludingIndex index: Int? = nil) -> Bool {
        for (currentIndex, existingPeg) in objects.enumerated() {
            if currentIndex != index && peg.overlaps(with: existingPeg) {
                return true
            }
        }
        return false
    }
    
    internal func isWithinBoard(_ peg: BoardObject) -> Bool {
        peg.isInBoundary(within: self.boardSize)
    }
}
