//
//  ListItems.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 **********   List Items Parser   ***********
 ********************************************/

/// listItemParagraph = inlineLine, {4 * space, inlineLine};

let listItemIndentation = space.amount(4)// <|> string("\t")

func listItemParagraph(depth: Int) -> Parser<ContainerNode> {
    
    let indentation = listItemIndentation.amount(depth)
    
    let lines =  ContainerNode.inlineLines <^> (indentation *> inlineLine).many
    let transformer: (InlineLine) -> Parser<ContainerNode> = {
        inline in
        
        let special = listItemFencedCodeBlock(depth: depth) <|> depthOrderedList(depth: depth + 1) <|> depthBulletList(depth: depth + 1)
        let elt = blankLine.optional *> (special <|> lines.except(special))
        return curry(ContainerNode.listItemParagraph)(inline) <^> elt.many.optional
    }
    
    return inlineLine >>- transformer
}

/// listItemFencedCodeBlock = "```", [infoString], lineEnding,
/// {4 * space, line},
/// 4 * space, "```", lineEnding;
func listItemFencedCodeBlock(depth: Int) -> Parser<ContainerNode> {
 
    let indentation = listItemIndentation.amount(depth)
    
    return curry(ContainerNode.listItemFencedCodeBlock) <^> (indentation *> string("```") *> textualContent.optional <* lineEnding) <*>
        (indentation *> line).except(indentation *> string("```")).many.optional <* indentation <* string("```") <* lineEnding
}

