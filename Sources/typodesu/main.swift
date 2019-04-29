//
//  SpellVisitor.swift
//  typodesu
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import SwiftSyntax
import SPMUtility
import Basic

let parser = ArgumentParser(usage: "Spell check", overview: "Spell check")
let arg = parser.add(positional: "path",
                     kind: String.self,
                     optional: false,
                     usage: "path of target file",
                     completion: nil)

do {
    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
    guard let cwd = localFileSystem.currentWorkingDirectory else { exit(1) }
    
    let path = AbsolutePath(result.get(arg) ?? "./", relativeTo: cwd)
    let syntaxTree = try SyntaxTreeParser.parse(path.asURL)
    syntaxTree.walk(SpellVisitor())
} catch {
    print(error.localizedDescription)
}
