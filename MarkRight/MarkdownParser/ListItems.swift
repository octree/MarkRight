//
//  ListItems.swift
//  MarkRight
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation
import FP
import ParserCombinator

/*********************************************
 **********   List Items Parser   ***********
 ********************************************/

/// listItemParagraph = inlineLine, {4 * space, inlineLine};

let listItemIndentation = space.repeat(4)// <|> string("\t")

func listItemParagraph(depth: Int) -> MDParser<ContainerNode> {
    
    let indentation = listItemIndentation.repeat(depth)
    
    let transformer: (InlineLine) -> MDParser<ContainerNode> = {
        inline in
        
        let special = listItemFencedCodeBlock(depth: depth) <|> depthOrderedList(depth: depth + 1) <|> depthBulletList(depth: depth + 1) <|> depthTaskList(depth: depth + 1)
        let lines =  ContainerNode.inlineLines <^> (indentation *> inlineLine).difference(special).many1
        let elt = blankLine.optional *> (special <|> lines)
        return curry(ContainerNode.listItemParagraph)(inline) <^> elt.many1.optional
    }
    
    return inlineLine >>- transformer
}

/// listItemFencedCodeBlock = "```", [infoString], lineEnding,
/// {4 * space, line},
/// 4 * space, "```", lineEnding;
func listItemFencedCodeBlock(depth: Int) -> MDParser<ContainerNode> {
 
    let indentation = listItemIndentation.repeat(depth)
    
    return curry(ContainerNode.listItemFencedCodeBlock) <^> (indentation *> string("```") *> textualContent.optional <* lineEnding) <*>
        (indentation *> line).difference(indentation *> string("```")).many <* indentation <* string("```") <* lineEnding
}

