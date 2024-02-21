//
//  Board.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 2/2/24.
//

import Foundation

struct Board {
    var pegs: [Peg] = []
    var boardSize: CGSize = .zero

    init(withSize boardSize: CGSize = CGSize()) {
        self.boardSize = boardSize
    }

    mutating func addPeg(at point: CGPoint, withType type: PegType,
                         withSize size: CGFloat = Constants.defaultAssetRadius) {
        let newPeg = Peg(center: CGPoint(x: point.x, y: point.y), type: type, radius: size)
        if !isOverlapping(newPeg) && isWithinBoard(newPeg) {
            pegs.append(newPeg)
        }
    }

    mutating func deletePeg(_ peg: Peg) {
        pegs.removeAll { $0 == peg }
    }

    mutating func updatePegPosition(index: Int, newPoint: CGPoint) {
        if index >= pegs.count {
            return
        }
        let oldPeg = pegs[index]
        let newPeg = Peg(center: newPoint, type: oldPeg.type)
        if isWithinBoard(newPeg) && !isOverlapping(newPeg, excludingIndex: index) {
            pegs[index] = newPeg
        }
    }

    mutating func setBoardSize(_ size: CGSize) {
        boardSize = size
    }
}

extension Board: Hashable & Codable {
    static func == (lhs: Board, rhs: Board) -> Bool {
        lhs.pegs == rhs.pegs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(pegs)
    }
}

// MARK: helpers
extension Board {
    internal func isOverlapping(_ peg: Peg, excludingIndex index: Int? = nil) -> Bool {
        for (currentIndex, existingPeg) in pegs.enumerated() {
            if currentIndex != index && peg.overlaps(with: existingPeg) {
                return true
            }
        }
        return false
    }

    internal func isWithinBoard(_ peg: Peg) -> Bool {
        peg.isInBoundary(within: self.boardSize)
    }
}
