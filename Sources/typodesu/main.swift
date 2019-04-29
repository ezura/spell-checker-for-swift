//
//  SpellVisitor.swift
//  typodesu
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import SwiftSyntax

let syntaxTree = try! SyntaxTreeParser.parse(URL(fileURLWithPath: "./Example/SampleViewModel.swift"))
syntaxTree.walk(SpellVisitor())
