//
//  SpellVisitor.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import Cocoa
import SPMUtility
import Basic
import SwiftSyntax

let parser = ArgumentParser(usage: "[options] argument", overview: "Spell check")
let arg = parser.add(positional: "path | init",
                     kind: String.self,
                     optional: true,
                     usage: "Path to target file | set up typokana",
                     completion: nil)
let optionForDiffOnly = parser.add(option: "--diff-only",
                                   shortName: "-diff",
                                   kind: Bool.self,
                                   usage: "Check only files listed by `git diff --name-only`")

let optionForLanguage = parser.add(option: "--language",
                                   shortName: "-l",
                                   kind: String.self,
                                   usage: "The language to use for spell checking, e.g. \"en_US\" (defaults to using the system language).")

do {
    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
    let argument = result.get(arg)
    if argument == "init" {
        setUpConfigurations()
        exit(0)
    }
    
    guard let cwd = localFileSystem.currentWorkingDirectory else { exit(1) }
    let path = AbsolutePath(result.get(arg) ?? "./", relativeTo: cwd)
    let shouldCheckDiffOnly = result.get(optionForDiffOnly) ?? false
    let targetFiles: [AbsolutePath] = try {
        if shouldCheckDiffOnly {
            let gitRoot = AbsolutePath(try getGitRoot())
            return try extractModifiedFiles().compactMap { path in
                let formattedPath = AbsolutePath(path, relativeTo: gitRoot)
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
    
    let spellChecker = NSSpellChecker.shared

    let ignoredWords = IgnoredWordList.read()
    spellChecker.setIgnoredWords(ignoredWords, inSpellDocumentWithTag: 0)

    if let language = result.get(optionForLanguage) {
        guard spellChecker.setLanguage(language) else {
            print(#""\#(language)" is not a valid language."#)
            print(#"Valid languages include: \#(spellChecker.availableLanguages.joined(separator: ", "))"#)
            exit(1)
        }
    }

    try targetFiles.forEach { 
        let syntaxTree = try SyntaxParser.parse($0.asURL)
        let sourceLocationConverter = SourceLocationConverter(file: $0.pathString, tree: syntaxTree)
        let spellVisitor = SpellVisitor(filePath: $0.pathString, spellChecker: spellChecker, sourceLocationConverter: sourceLocationConverter)
        spellVisitor.walk(syntaxTree)
    }
} catch {
    print(error.localizedDescription)
}


func setUpConfigurations() {
    IgnoredWordList.generateTemplateFileIfNeeds()
    print("✅ complete")
}
