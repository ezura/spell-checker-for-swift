//
//  FileUtil.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import Basic

func visitSwiftFiles(in root: AbsolutePath, onFind: (AbsolutePath) throws -> Void) rethrows {
    if root.extension == "swift" {
        try onFind(root)
    } else {
        for content in (try? localFileSystem.getDirectoryContents(root)) ?? [] {
            let path = AbsolutePath(content, relativeTo: root)
            try visitSwiftFiles(in: path, onFind: onFind)
        }
    }
}

func extractModifiedFiles() throws -> [String] {
    let processOfGitDiff = Process(args: "git", "diff", "--name-only")
    try processOfGitDiff.launch()
    let result = try processOfGitDiff.waitUntilExit()
    return try result.utf8Output().split(separator: "\n").map { String($0) }
}
