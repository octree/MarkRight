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
private let MDParser = { $0 } <^> block.many

private let theme: String = {
  
    let path = Bundle.main.path(forResource: "theme", ofType: "css")!
    return try! String(contentsOfFile: path)
}()

struct MarkdownParser {
    
    static func parse(_ text: String) -> Reply<Parser<Any>.Stream, [MarkdownNode]> {
        return MDParser.parse(Substring(text + "\n"))
    }
    
    static func toHTML(_ text: String) -> String? {
        
        let result = parse(text).map { rt -> String in
            let html = rt.map { $0.htmlText }.joined(separator: "\n")
            
            return """
            <html>
                <head>
                    <link rel="stylesheet" href="http://obb77efas.bkt.clouddn.com/solarized-dark-1.css">
                    <script src="http://obb77efas.bkt.clouddn.com/highlight.pack.js"></script>
                    <link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">
                    <style type = "text/css">
                    \(theme)
                    </style>
                    <script>
            
                    window.oct_scroll = function(r) {
                        let bodyH = document.body.scrollHeight
                        let screenH = screen.height
                        let outH = bodyH - screenH
                        if (outH < 0) {
                            outH = 0
                        }
                        document.body.scrollTop = r * outH
                    }
                    </script>
                </head>
                <body>
                    \(html)
                </body>
                <script>hljs.initHighlightingOnLoad();</script>
            </html>
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

