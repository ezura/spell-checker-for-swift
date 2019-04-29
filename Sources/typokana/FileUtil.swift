//
//  FileUtil.swift
//  typokana
//
//  Created by yuka ezura on 2019/04/29.
//

import Foundation
import Basic

func visitFiles(in root: AbsolutePath, onFind: (AbsolutePath) throws -> Void) rethrows {
    if root.extension == "swift" {
        try onFind(root)
    } else {
        for content in (try? localFileSystem.getDirectoryContents(root)) ?? [] {
            let path = AbsolutePath(content, relativeTo: root)
            try visitFiles(in: path, onFind: onFind)
        }
    }
}
