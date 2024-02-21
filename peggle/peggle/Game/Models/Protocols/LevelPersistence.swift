//
//  LevelPersistence.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 25/1/24.
//

protocol LevelPersistence {
    static func saveLevel(_ level: Level)
    static func loadLevel(with name: String) -> Level?
    static func deleteLevel(name: String)
    static func displayAllLevels() -> [String]
}

enum PersistenceError: Error {
    case documentDirectoryNotFound
    case encodeError
    case writeError
    case fileNotFound
    case readError
}
