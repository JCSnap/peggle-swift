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
    
    mutating func addObject(_ object: BoardObject) {
        if isWithinBoardAndNotOverlapping(object: object) {
            objects.append(object)
        }
    }

    mutating func replaceObject(at index: Int, with newObject: BoardObject) {
        objects[index] = newObject
    }
    
    mutating func deleteBoardObject(_ object: BoardObject) {
        objects.removeAll { $0 == object }
    }
    
    mutating func updateObjectPosition(index: Int, newPoint: CGPoint) {
        guard index < objects.count else { return }
        let oldObject = objects[index]
        let newObject = createNewObject(at: newPoint, from: oldObject)
 
        if isWithinBoardAndNotOverlapping(object: newObject, index: index) {
            objects[index] = newObject
        }
    }
    
    mutating func updateObjectSize(index: Int, newSize: CGFloat) {
        guard index < objects.count else { return }
        let objectToEdit = objects[index]
        if newSize <= objectToEdit.size {
            objectToEdit.updateSize(to: newSize)
            return
        }
        if isWithinBoardAndNotOverlapping(object: objectToEdit, index: index) {
            objectToEdit.updateSize(to: newSize)
        }
    }
    
    mutating func updateObjectAngle(index: Int, newAngleInDegree: CGFloat) {
        guard index < objects.count else { return }
        let objectToEdit = objects[index]
        let oldAngle = objectToEdit.angle
        let newAngleInRadian = newAngleInDegree * .pi / 180
        objectToEdit.updateAngle(to: newAngleInRadian)
        if !isWithinBoardAndNotOverlapping(object: objectToEdit, index: index) {
            objectToEdit.updateAngle(to: oldAngle)
        }
    }

    mutating func setBoardSize(_ size: CGSize) {
        boardSize = size
    }
    
    func getIndexOf(object: BoardObject) -> Int {
        objects.firstIndex(where: { $0 === object }) ?? 0
    }
    
    private func createNewObject(at point: CGPoint, from object: BoardObject) -> BoardObject {
        if let peg = object as? Peg {
            return Peg(center: point, type: peg.type, radius: peg.radius)
        } else if let obstacle = object as? Obstacle {
            return Obstacle(center: point, type: obstacle.type, size: obstacle.size, angle: obstacle.angle)
        } else {
            fatalError("Object needs to be a subclass of BoardObject")
        }
    }
                
    private func isWithinBoardAndNotOverlapping(object: BoardObject, index: Int? = nil) -> Bool {
        isWithinBoard(object) && !isOverlapping(object, excludingIndex: index)
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
        case obstacle = "Obstacle"
    }
    
    private enum CodingKeys: String, CodingKey {
        case objects, boardSize
    }
    
    private enum ObjectTypeKey: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var objectsArray = try container.nestedUnkeyedContainer(forKey: .objects)
        var objects = [BoardObject]()

        while !objectsArray.isAtEnd {
            let objectContainer = try objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)
            let type = try objectContainer.decode(String.self, forKey: .type)
            
            switch type {
            case "Peg":
                let peg = try objectsArray.decode(Peg.self)
                objects.append(peg)
            case "Obstacle":
                let obstacle = try objectsArray.decode(Obstacle.self)
                objects.append(obstacle)
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: objectContainer, debugDescription: "Unknown type")
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
            } else if let obstacle = object as? Obstacle {
                try objectContainer.encode(BoardObjectType.obstacle, forKey: .type)
                try objectsArray.encode(obstacle)
            } else {
                fatalError("Unknown BoardObject subclass")
            }
        }
    }
}

// MARK: helpers
extension Board {
    internal func isOverlapping(_ object: BoardObject, excludingIndex index: Int? = nil) -> Bool {
        for (currentIndex, existingObject) in objects.enumerated() {
            if currentIndex != index && object.overlaps(with: existingObject) {
                return true
            }
        }
        return false
    }
    
    internal func isWithinBoard(_ object: BoardObject) -> Bool {
        object.isInBoundary(within: self.boardSize)
    }
}


enum ObjectType: Equatable, Codable {
    case peg(PegType)
    case obstacle(ObstacleType)
    
    enum PegType: Codable {
        case normal, scoring, exploding, stubborn
    }
    
    enum ObstacleType: Codable {
        case rectangle, triangle, circle
    }
}

extension ObjectType.ObstacleType {
    var stringValue: String {
        switch self {
        case .rectangle:
            return "rectangle"
        case .triangle:
            return "triangle"
        case .circle:
            return "circle"
        }
    }

    init?(stringValue: String) {
        switch stringValue {
        case "rectangle":
            self = .rectangle
        case "triangle":
            self = .triangle
        case "circle":
            self = .circle
        default:
            return nil
        }
    }
}
