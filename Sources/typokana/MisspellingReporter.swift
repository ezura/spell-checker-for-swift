//
//  MisspellingReporter.swift
//  typokana
//
//  Created by yuka ezura on 2019/05/05.
//

import Foundation
import Basic
import SwiftSyntax

class MisspellingReporter {
    func reportMisspelled(in targetFilePath: AbsolutePath) throws {
        let syntaxTree = try SyntaxTreeParser.parse(targetFilePath.asURL)
        syntaxTree.walk(SpellVisitor(filePath: targetFilePath.pathString))
    }
}
