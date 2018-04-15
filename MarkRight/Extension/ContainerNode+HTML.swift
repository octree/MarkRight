//
//  ContainerNode+HTML.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


extension ContainerNode: HTMLConversionProtocol {
    
    var htmlText: String {
        switch self {
        
        case let .inlineLines(lines):
            return """
            <p>\(lines.htmlText)</p>
            """
        case let .blockQuote(lines):
            return """
            <blockquote><p>\(lines.map { $0.htmlText }.joined(separator: "<br/>"))</p></blockquote>
            """
        case let .bulletList(items):
            return """
            <ul>
            \(items.htmlText)
            </ul>
            """
        case let .orderedList(item):
            return """
            <ol>
                \(item.htmlText)
            </ol>
            """
        case let .listItemParagraph(main, nodes):
            
            let son = nodes.map {
                return """
                \($0.htmlText)
                """
            }
            
            return """
            <li>\(main.htmlText)</li>
            \(son ?? "")
            """
        case let .listItemFencedCodeBlock(info, lines):
            let code = (lines ?? []).map { $0.htmlEscape() }.joined(separator: "\n")
            
            return """
            <pre><code class="\(info?.htmlEscape() ?? "")">\(code)</code></pre>
            """
        case let .taskListItem(checked, node):
            
            guard case let .listItemParagraph(main, sons) = node else {
                return ""
            }
            let son = sons.map {
                return """
                \($0.htmlText)
                """
            }
            return """
            <li class = "task-list-item">
            <input type="checkbox" disabled class="task-list-item-checkbox" \(checked ? "checked" : "")>
            <span class="checkmark"></span>
            \(main.htmlText)
            </li>
             \(son ?? "")
            """
        case let .taskList(nodes):
            return """
            <ul class = "task-list-container">
                \(nodes.htmlText)
            </ul>
            """
        }
        
    }
}
