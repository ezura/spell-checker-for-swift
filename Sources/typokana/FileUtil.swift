//
//  FileUtil.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import Basic

func visitFiles(in root: AbsolutePath, onFind: (AbsolutePath) throws -> Void) rethrows {
    if root.extension == "swift" {
        try onFind(root)
    } else {
        for content in (try? localFileSystem.getDirectoryContents(root)) ?? [] {
            let path = AbsolutePath(content, relativeTo: root)
            try visitFiles(in: path, onFind: onFind)
        }
    }
}

func extractModifiedFiles() throws -> [String] {
    let processOfGitDiff = Process(args: "git", "diff", "--diff-filter=d", "--name-only", "HEAD")
    try processOfGitDiff.launch()
    let result = try processOfGitDiff.waitUntilExit()
    return try result.utf8Output().split(separator: "\n").map { String($0) }
}

func readIgnoredWordList() -> [String] {
    do {
        let list = try String(contentsOfFile: "./.typokana_ignore", encoding: .utf8)
        return list.split(separator: "\n")
            .filter { !$0.hasPrefix("#") } // Remove comment lines
            .map { String($0) }
    } catch {
        print("\u{001B}[42mwarning: ignore list could not read.\u{001B}[0m")
        return []
    }
}
