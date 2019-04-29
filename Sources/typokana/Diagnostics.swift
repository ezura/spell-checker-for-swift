//
//  Diagnostics.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation

struct Diagnostics {
    func emit(filePath: String, line: Int, column: Int, message: String) {
        print("\(filePath):\(line):\(column): warning: \(message)")
    }
}
