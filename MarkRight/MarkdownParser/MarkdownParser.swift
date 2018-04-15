//
//  MarkdownParser.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 **********    Markdown Parser    ***********
 ********************************************/

/// block = containerBlock | leafBlock;
let block = containerBlock <|> leafBlock
private let markdownParser = { $0 } <^> block.many

struct MarkdownParser {
    
    static func parse(_ text: String) -> Reply<Substring, [MarkdownNode]> {
        return markdownParser.parse(Substring(text + "\n"))
    }
    
    static func toHTML(_ text: String) -> String? {
        
        let result = parse(text).map { rt -> String in
            let html = rt.map { $0.htmlText }.joined(separator: "\n")
            
            return """
            <div class = "markdown">
            \(html)
            </div>
            """
        }
        switch result {
        case let .done(_, html):
            return html
        default:
            return nil
        }
    }
}

