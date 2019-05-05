//
//  SpellVisitor.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import SPMUtility
import Basic
import SwiftSyntax

let parser = ArgumentParser(usage: "[options] argument", overview: "Spell check")
let arg = parser.add(positional: "path",
                     kind: String.self,
                     optional: true,
                     usage: "Path of target file",
                     completion: nil)
let optionForDiffOnly = parser.add(option: "--diff-only",
                                   shortName: "-diff",
                                   kind: Bool.self,
                                   usage: "Check only files listed by `git diff --name-only`")

do {
    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
    guard let cwd = localFileSystem.currentWorkingDirectory else { exit(1) }
    let path = AbsolutePath(result.get(arg) ?? "./", relativeTo: cwd)
    let shouldCheckDiffOnly = result.get(optionForDiffOnly) ?? false
    let targetFiles: [AbsolutePath] = try {
        if shouldCheckDiffOnly {
            return try extractModifiedFiles().compactMap { path in
                let formattedPath = AbsolutePath(path, relativeTo: cwd)
                guard formattedPath.extension == "swift" else { return nil }
                return formattedPath
            }
        } else {
            var targetFileBuffer: [AbsolutePath] = []
            visitFiles(in: path) { (path) in
                guard path.extension == "swift" else { return }
                targetFileBuffer.append(path)
            }
            return targetFileBuffer
        }
    }()
    
    try targetFiles.forEach { 
        let syntaxTree = try SyntaxTreeParser.parse($0.asURL)
        syntaxTree.walk(SpellVisitor(filePath: $0.pathString))
    }
} catch {
    print(error.localizedDescription)
}
