//
//  InlineNode.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

typealias InlineLine = [InlineNode]

enum InlineNode {
    
    case textualContent(String)
    //    ![desc](url)
    case image(desc: String, url: String?)
    //    `xxxxx`
    case codeSpan(String)
    //    *xxx*
    case emphasis(String)
    //    **xxx**
    case strongEmphasis(String)
    //    [text](url)
    case inlineLink(text: String, url: String?)
}
