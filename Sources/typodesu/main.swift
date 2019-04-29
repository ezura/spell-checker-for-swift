import Cocoa
import SwiftSyntax
import SwiftSyntaxExtensions

class SpellVisitor: SyntaxVisitor {
    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        for comment in token.leadingTrivia.compactMap({ $0.comment }) {
            let misspellRange = NSSpellChecker.shared.checkSpelling(of: comment, startingAt: 0)
            if misspellRange.location < comment.count {
                print((comment as NSString).substring(with: misspellRange))
            }
        }
        
        let tokenWithoutTrivia = token.withoutTrivia().text
        let formedText = tokenWithoutTrivia.reduce([]) { (r, c) -> [String] in
            var _r = r
            if c.isUppercase {
                _r.append(String(c))
            } else {
                var lastText = (_r.popLast() ?? "")
                lastText.append(c)
                _r.append(lastText)
            }
            return _r
        }.joined(separator: " ")
        let misspellRange = NSSpellChecker.shared.checkSpelling(of: formedText, startingAt: 0)
        if misspellRange.location < formedText.count {
            print((formedText as NSString).substring(with: misspellRange))
        }
        
        return super.visit(token)
    }
}

let syntaxTree = try! SyntaxTreeParser.parse(URL(fileURLWithPath: "./Example/SampleViewModel.swift"))
syntaxTree.walk(SpellVisitor())
