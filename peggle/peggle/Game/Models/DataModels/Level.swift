//
//  Level.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/1/24.
//

import Foundation

/// For the current implementation, the name is unique. However, it is possible to image a peggle game where
/// users can create multiple levels with the same name. It might be better to have other unique identifiers for levels
struct Level {
    let name: String
    let board: Board
}

extension Level: Hashable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.name == rhs.name && lhs.board == rhs.board
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(board)
    }
}

extension Level: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case board
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(board, forKey: .board)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        board = try container.decode(Board.self, forKey: .board)
    }
}
