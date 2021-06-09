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

func getGitRoot() throws -> String {
    let process = Process(args: "git", "rev-parse", "--show-toplevel")
    try process.launch()
    let result = try process.waitUntilExit()
    return try result.utf8Output().trimmingCharacters(in: .newlines)
}

func extractModifiedFiles() throws -> [String] {
    let processOfGitDiff = Process(args: "git", "diff", "--diff-filter=d", "--name-only", "HEAD")
    try processOfGitDiff.launch()
    let result = try processOfGitDiff.waitUntilExit()
    return try result.utf8Output().split(separator: "\n").map { String($0) }
}
