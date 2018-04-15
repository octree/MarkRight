//
//  BlockNode+HTML.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension TableDataAlignment: HTMLConversionProtocol {
    
    var htmlText: String {
        
        switch self {
        case .center:
            
            return """
            align="center"
            """
        case .left:
            
            return """
            align="left"
            """
        case .right:
            
            return """
            align="right"
            """
        }
    }
}

private func headerHTMLString(text: String, level: Int) -> String {
    
    let id = String(text.filter { !NSCharacterSet.whitespaces.contains($0) && $0 != "\"" })
    return """
    <h\(level) id="\(id)">\(text)</h\(level)>
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
            <pre><code class="\(info?.htmlEscape() ?? "")">\(code)</code></pre>
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
        case let .tableHeading(align, inlines):
            
            return """
            <th \(align.htmlText)>\(inlines.htmlText)</th>
            """
        case let .tableData(align, inlines):
            return """
            <td \(align.htmlText)>\(inlines.htmlText)</td>
            """
        case let .tableRow(items):
            return """
            <tr>
                \(items.htmlText)
            </tr>
            """
        case let .table(thr, tdr):
            return """
            <table>
                <thead>
                    \(thr.htmlText)
                </thead>
                <tbody>
                    \(tdr.htmlText)
                </tbody>
            </table>
            """
        }
    }
}
