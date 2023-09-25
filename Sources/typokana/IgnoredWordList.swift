//
//  IgnoredWordList.swift
//  typokana
//
//  Created by yuka ezura on 2020/09/19.
//

import Foundation
import TSCBasic

enum IgnoredWordList {
    
    static private let fileName = ".typokana_ignore"
    static private let filePath = "./\(fileName)"
    
    static func read() -> [String] {
        do {
            let list = try String(contentsOfFile: filePath, encoding: .utf8)
            return list.split(separator: "\n")
                .filter { !$0.hasPrefix("#") } // Remove comment lines
                .map { String($0) }
        } catch {
            print("\u{001B}[42mwarning: ignore list could not read.\u{001B}[0m")
            return []
        }
    }
    
    static func generateTemplateFileIfNeeds() {    
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: filePath) { return
            print("\(fileName) file exists. skip the step to generate \(fileName) file.")
        }
        let isFileCreated = fileManager.createFile(atPath: filePath,
                                                   contents: template.data(using: .utf8),
                                                   attributes: nil)
        if isFileCreated {
            print("success: '\(fileName)' created")
        } else {
            print("\u{001B}[42mfail: '\(fileName)' can't be created\u{001B}[0m")
        }
    }
}

extension IgnoredWordList {
    private static let template = 
    """
    # Add words that the spell checker should ignore.
    # (`#` means a line comment.)
    deinit
    Hashable
    Iterable
    Codable
    autoclosure
    json

    # rx
    # snp
    """
}
