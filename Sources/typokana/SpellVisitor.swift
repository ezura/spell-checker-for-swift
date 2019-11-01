//
//  SpellVisitor.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import Cocoa
import SwiftSyntax
import SwiftSyntaxExtensions

class SpellVisitor: SyntaxVisitor {
    let filePath: String
    let spellChecker: NSSpellChecker
    
    init(filePath: String, spellChecker: NSSpellChecker) {
        self.filePath = filePath
        self.spellChecker = spellChecker
    }
    
    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        for comment in token.leadingTrivia.compactMap({ $0.comment }) {
            let misspellRange = spellChecker.checkSpelling(of: comment, startingAt: 0)
            if misspellRange.location < comment.count {
                printMisspelled(forWordRange: misspellRange,
                                in: comment,
                                position: token.positionAfterSkippingLeadingTrivia)
            }
        }
        
        switch token.tokenKind {
        case .stringLiteral(let text),
             .unknown(let text),
             .identifier(let text),
             .dollarIdentifier(let text),
             .stringSegment(let text):
            let formedText = text.reduce([]) { (r, c) -> [String] in
                var _r = r
                if c.isUppercase {
                    _r.append(String(c))
                } else if c == "_" || c == "." {
                    _r.append("")
                } else {
                    var lastText = (_r.popLast() ?? "")
                    lastText.append(c)
                    _r.append(lastText)
                }
                return _r
                }.joined(separator: " ")
            let misspelledRange = spellChecker.checkSpelling(of: formedText, startingAt: 0)
            if misspelledRange.location < formedText.count {
                printMisspelled(forWordRange: misspelledRange,
                                in: formedText,
                                position: token.position)
                // TODO: Resume check spelling from continuation of text
            }
        default:
            break
        }
        
        return super.visit(token)
    }
    
    private func printMisspelled(forWordRange misspelledRange: NSRange, in string: String, position: AbsolutePosition) {
        let suggestedWord = spellChecker.correction(forWordRange: misspelledRange,
                                                             in: string,
                                                             language: spellChecker.language(),
                                                             inSpellDocumentWithTag: 0)
        var message: String {
            let targetWord = (string as NSString).substring(with: misspelledRange)
            if let suggestedWord = suggestedWord {
                return #""\#(targetWord)": did you mean "\#(suggestedWord)"? (CheckSpelling)"#
            } else {
                return #""\#(targetWord)" (CheckSpelling)"#
            }
        }
        Diagnostics().emit(filePath: filePath,
                           line: position.line,
                           column: position.column,
                           message: message)
    }
}
