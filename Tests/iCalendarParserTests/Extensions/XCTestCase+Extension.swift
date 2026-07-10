//
//  XCTestCase+Extension.swift
//
//
//  Created by Adrian Bolinger on 7/28/24.
//

import XCTest

extension XCTestCase {
    /// Reads the contents of a file located in the test directory's "Resources" folder.
    ///
    /// - Parameters:
    ///   - filename: The name of the file (without extension).
    ///   - ext: The extension of the file.
    /// - Returns: The contents of the file as a String.
    /// - Throws: An error if the file cannot be read.
    func getContents(of filename: String, ext: String, file: StaticString = #filePath) throws -> String {
        // Get the directory of the current file
        let currentFilePath = String(describing: file)
        let currentDirectoryPath = URL(fileURLWithPath: currentFilePath).deletingLastPathComponent()

        // Construct the full file path
        let fileURL = currentDirectoryPath.appendingPathComponent("Resources/\(filename).\(ext)")

        // Ensure the file exists
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw NSError(domain: "FileNotFoundError", code: 1, userInfo: [NSLocalizedDescriptionKey: "File \(filename).\(ext) not found at path \(fileURL.path)."])
        }

        // Read the contents of the file
        let fileContents = try String(contentsOf: fileURL, encoding: .utf8)

        return fileContents
    }
}
