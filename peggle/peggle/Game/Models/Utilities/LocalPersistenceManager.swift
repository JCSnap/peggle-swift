//
//  PersistenceManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 24/1/24.
//

import Foundation

struct LocalPersistenceManager: LevelPersistence {
    // TODO: throw the error in the future to force the implementee to handle it,
    // right now it is fine to just print here
    static func saveLevel(_ level: Level) {
        do {
            let jsonData = try encodeLevelToJson(level)
            try saveDataToFile(jsonData, withName: level.name)
        } catch {
            print("Error saving level: \(error)")
        }
    }

    // TODO: throw error
    static func loadLevel(with name: String) -> Level? {
        do {
            let fileURL = try getFileURL(forName: name)
            let jsonData = try readDataFromFile(at: fileURL)
            return try decodeLevelFromJson(jsonData)
        } catch {
            print("Error saving level: \(error)")
            return nil
        }
    }

    static func deleteLevel(name: String) {
        do {
            let fileURL = try getFileURL(forName: name)
            try FileManager.default.removeItem(at: fileURL)
            print("Level \(name) deleted successfully.")
        } catch {
            print("Error deleting level: \(error)")
        }
    }

    // TODO: throw error
    static func displayAllLevels() -> [String] {
        do {
            let fileURLs = try getFileURLs()
            return extractLevelNames(from: fileURLs)
        } catch {
            print("Error reading document directory: \(error)")
            return []
        }
    }
}

// MARK: helpers
extension LocalPersistenceManager {
    private static func encodeLevelToJson(_ level: Level) throws -> Data {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(level)
        } catch {
            throw PersistenceError.encodeError
        }
    }

    private static func getDocumentDirectoryURL() throws -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw PersistenceError.documentDirectoryNotFound
        }
        return url
    }

    private static func saveDataToFile(_ data: Data, withName name: String) throws {
        let documentDirectory = try getDocumentDirectoryURL()
        let fileURL = documentDirectory.appendingPathComponent("\(name).json")

        do {
            try data.write(to: fileURL, options: .atomicWrite)
        } catch {
            throw PersistenceError.writeError
        }
    }

    private static func getFileURL(forName name: String) throws -> URL {
        let documentDirectory = try getDocumentDirectoryURL()
        let fileURL = documentDirectory.appendingPathComponent("\(name).json")

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw PersistenceError.fileNotFound
        }

        return fileURL
    }

    private static func readDataFromFile(at url: URL) throws -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            throw PersistenceError.readError
        }
    }

    private static func decodeLevelFromJson(_ jsonData: Data) throws -> Level {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Level.self, from: jsonData)
        } catch {
            throw PersistenceError.encodeError
        }
    }

    private static func getFileURLs() throws -> [URL] {
        let directory = try getDocumentDirectoryURL()
        return try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
    }

    private static func extractLevelNames(from fileURLs: [URL]) -> [String] {
        fileURLs
            .filter { $0.pathExtension == "json" }
            .map { $0.deletingPathExtension().lastPathComponent }
    }
}
