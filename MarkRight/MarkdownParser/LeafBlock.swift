//
//  LeafBlock.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 **********   Leaf Block Parser   ***********
 ********************************************/

/// thematicBreak = (3 * "-"), {-}, {space}, lineEnding;
let thematicBreak = { _ in return BlockNode.thematicBreak } <^> string("---").followed(by: string("-").many).followed(by: space.many).followed(by: lineEnding)


///(*Inline Parsing ommitted, for now the Headings can only be simple Text*)


/// atxHeading1 = "#", space, textualContent, atxClosingSequence;
let atxHeading1 = BlockNode.h1 <^> (string("#") *> space *> textualContent <* space.many <* lineEnding)

/// atxHeading2 = "##", space, textualContent, atxClosingSequence;
let atxHeading2 = BlockNode.h2 <^> (string("##") *> space *> textualContent <* space.many <* lineEnding)

/// atxHeading3 = "###", space, textualContent, atxClosingSequence;
let atxHeading3 = BlockNode.h3 <^> (string("###") *> space *> textualContent <* space.many <* lineEnding)

/// atxHeading4 = "####", space, textualContent, atxClosingSequence;
let atxHeading4 = BlockNode.h4 <^> (string("####") *> space *> textualContent <* space.many <* lineEnding)

/// atxHeading5 = "#####", space, textualContent, atxClosingSequence;
let atxHeading5 = BlockNode.h5 <^> (string("#####") *> space *> textualContent <* space.many <* lineEnding)

/// atxHeading6 = "######", space, textualContent, atxClosingSequence;
let atxHeading6 = BlockNode.h6 <^> (string("######") *> space *> textualContent <* space.many <* lineEnding)

/// atxHeading = atxHeading1 | atxHeading2 | atxHeading3 | atxHeading4 | atxHeading5 | atxHeading6;
let atxHeading = atxHeading1 <|> atxHeading2 <|> atxHeading3 <|> atxHeading4 <|> atxHeading5 <|> atxHeading6

/// blankLines = blankLine, {blankLine};
let blankLines = { BlockNode.blankLines($0.count) } <^> blankLine.many1

/// indentedChunk = (4 * space, {space}, nonBlankLine), {(4 * space, {space}, nonBlankLine)};
let indentedChunk =  BlockNode.indentedChunk <^> (space.repeat(4) *> space.many *> nonBlankLine).many1

/// indentedCodeBlock = blankLine, (indentedChunk, blankLine), {(indentedChunk, blankLine)};
let indentedCodeBlock =  BlockNode.indentedCodeBlock <^> (blankLine *> (indentedChunk <* blankLine).many1)

/// fencedCodeBlock = ("```", [infoString], lineEnding,
///    {line},
/// "```", lineEnding);
let fencedCodeBlock = curry(BlockNode.fencedCodeBlock) <^> (string("```") *> textualContent.optional <* lineEnding) <*>
                    line.difference(string("```")).many <* string("```") <* lineEnding

/// paragraph = inlineLine, {inlineLine};
private let specialLeaf = thematicBreak <|> atxHeading <|> indentedCodeBlock <|> fencedCodeBlock <|> blankLines
let paragraph = BlockNode.paragraph <^> inlineLine.difference(specialLeaf).many1

// leafBlock = thematicBreak | atxHeading | indentedCodeBlock | fencedCodeBlock | linkReferenceDefinition | paragraph | blankLines;
let leafBlock = MarkdownNode.leaf <^> ( specialLeaf <|> paragraph )

