//
//  IgnoredWordList.swift
//  typokana
//
//  Created by yuka ezura on 2020/09/19.
//

import Foundation

enum IgnoredWordList {
    
    static let filePath = "./.typokana_ignore"
    
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

    # rx
    # snp
    """
}
