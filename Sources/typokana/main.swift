//
//  SpellVisitor.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import SwiftSyntax
import SPMUtility
import Basic

let parser = ArgumentParser(usage: "[options] argument", overview: "Spell check")
let arg = parser.add(positional: "path",
                     kind: String.self,
                     optional: false,
                     usage: "Path of target file",
                     completion: nil)

do {
    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
    guard let cwd = localFileSystem.currentWorkingDirectory else { exit(1) }
    let path = AbsolutePath(result.get(arg) ?? "./", relativeTo: cwd)
    try visitFiles(in: path) { (path) in
        let syntaxTree = try SyntaxTreeParser.parse(path.asURL)
        syntaxTree.walk(SpellVisitor(filePath: path.pathString))
    }
} catch {
    print(error.localizedDescription)
}
