//
//  ContainerNode.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


//typealias OrderedListItem = (ListItemLeafBlock)
//typealias BulletListItem = (Character, ListItemLeafBlock)

indirect enum ContainerNode {
    
    case inlineLines([InlineLine])
    case listItemParagraph(main: InlineLine, sub: [ContainerNode]?)
    case listItemFencedCodeBlock(info: String?, lines: [String]?)
    case blockQuote([InlineLine])
    //    [bulletListItem]
    case bulletList([ContainerNode])
    //    [orderedListItem]
    case orderedList([ContainerNode])
}
