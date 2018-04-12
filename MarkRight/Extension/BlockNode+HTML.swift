//
//  BlockNode+HTML.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

private func headerHTMLString(text: String, level: Int) -> String {
    
    return """
    <h\(level)>\(text)</h\(level)>
    """
}

extension BlockNode: HTMLConversionProtocol {
    
    var htmlText: String {
        switch self {
        case .h1(let h):
            return headerHTMLString(text: h.htmlEscape(), level: 1)
        case .h2(let h):
            return headerHTMLString(text: h.htmlEscape(), level: 2)
        case .h3(let h):
            return headerHTMLString(text: h.htmlEscape(), level: 3)
        case .h4(let h):
            return headerHTMLString(text: h.htmlEscape(), level: 4)
        case .h5(let h):
            return headerHTMLString(text: h.htmlEscape(), level: 5)
        case .h6(let h):
            return headerHTMLString(text: h.htmlEscape(), level: 6)
        case let .fencedCodeBlock(info, lines):
            let code = (lines ?? []).map{ $0.htmlEscape() }.joined(separator: "\n")
            return """
            <pre><code class="\(info ?? "")">\(code)</code></pre>
            """
        case .thematicBreak:
            return """
            <hr/>
            """
        case let .blankLines(n):
            return [String](repeating: "<br/>", count: n).joined()
        case let .paragraph(lines):
            return """
            <p>
            \(lines.htmlText)
            </p>
            """
        case let .indentedChunk(strings):
            return """
            \(strings.map { $0.htmlEscape() }.joined())
            """
        case let .indentedCodeBlock(chunks):
            return """
            \(chunks.htmlText)
            """
        }
    }
}
