//
//  ContainerItems.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 ********** Container Items Parser ***********
 ********************************************/

/// blockQuoteMarker = ">", [" "];
let blockQuoteMarker = string(">") <* string(" ").optional
//  blockQuote = blockQuteMarker, inlineLine, {blockQuteMarker, inlineLine};   (*2. Laziness is ignored for now*)
let blockQuote = ContainerNode.blockQuote <^> (blockQuoteMarker *> inlineLine).many

/// bulletListMarker = "-";    (*plus and star ignored for now*)
let bulletListMarker = character { "+-*".contains($0) }
func depthBulletListMarker(depth: Int) -> Parser<Character> {
    
    let indentation = space.amount(4 * depth - 4)
    return indentation *> bulletListMarker
}

/// orderedListMarker = digit, "."                            | ")";
let digits = character { CharacterSet.decimalDigits.contains($0) }.many
let orderedListMarker = digits <* string(".")
func depthOrderedListMarker(depth: Int) -> Parser<[Character]> {
    
    let indentation = space.amount(4 * depth - 4)
    return indentation *> orderedListMarker
}

/// listMarker = bulletListMarker | orderedListMarker;
//let listMarker = bulletListMarker <|> orderedListMarker

/// bulletListItem = bulletListMarker, 3 * space, listItemLeafBlock;
func depthBulletListItem(depth: Int) -> Parser<ContainerNode> {
    
    let indentation = space.amount(4 * depth - 4)
    return indentation *> bulletListMarker *> listItemParagraph(depth: depth)
}

/// orderedListItem = orderedListMarker, 2 * space, listItemLeafBlock;
func depthOrderedListItem(depth: Int) -> Parser<ContainerNode> {
    
    let indentation = space.amount(4 * depth - 4)
    return indentation *> orderedListMarker *> listItemParagraph(depth: depth)
}

/// orderedList = orderedListItem, [blankLine], {orderedListItem, [blankLine]};
func depthOrderedList(depth: Int) -> Parser<ContainerNode> {
    
    return ContainerNode.orderedList <^> (depthOrderedListItem(depth: depth) <* blankLine.optional).many
}

/// bulletList = bulletListItem, [blankLine], {bulletListItem, [blankLine]};
func depthBulletList(depth: Int) -> Parser<ContainerNode> {
    
    return ContainerNode.bulletList <^> (depthBulletListItem(depth: depth) <* blankLine.optional).many
}

//containerBlock = blockQuote;
let containerBlock =  MarkdownNode.container <^> (blockQuote <|> depthOrderedList(depth: 1) <|> depthBulletList(depth: 1))
