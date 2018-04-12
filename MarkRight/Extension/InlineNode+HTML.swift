//
//  InlineNode+HTML.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension InlineNode: HTMLConversionProtocol {
    
    var htmlText: String {
        
        switch self {
            
        case .textualContent(let text):
            return text.htmlEscape()
        case let .image(desc, url):
            return """
            <img src = "\(url ?? "")" alt = "\(desc)" />
            """
        case let .codeSpan(text):
            return """
            <code>\(text.htmlEscape())</code>
            """
        case let .emphasis(text):
            return """
            <em>\(text.htmlEscape())</em>
            """
        case let .strongEmphasis(text):
            return """
            <strong>\(text.htmlEscape())</strong>
            """
        case let .inlineLink(text, url):
            return """
            <a href = "\(url ?? "")">\(text.htmlEscape())</a>
            """
        }
    }
}
