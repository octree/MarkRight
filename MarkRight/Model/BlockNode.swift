//
//  BlockNode.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

enum TableDataAlignment {
    
    case left
    case center
    case right
}

indirect enum BlockNode {
    
    case h1(String)
    case h2(String)
    case h3(String)
    case h4(String)
    case h5(String)
    case h6(String)
    
    case fencedCodeBlock(info: String?, lines: [String]?)
    
    case thematicBreak
    case blankLines(Int)
    case paragraph([InlineLine])
    case indentedChunk([String])
//  [indentedChunk]
    case indentedCodeBlock([BlockNode])
    case tableHeading(TableDataAlignment, [InlineNode])
    case tableData(TableDataAlignment, [InlineNode])
    case tableRow([BlockNode])
    case table(BlockNode, [BlockNode])
}
