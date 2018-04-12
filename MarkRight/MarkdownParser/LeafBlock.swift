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
let thematicBreak = { _ in return BlockNode.thematicBreak } <^> string("---").followed(by: string("-").many.optional).followed(by: space.many.optional).followed(by: lineEnding)


///(*Inline Parsing ommitted, for now the Headings can only be simple Text*)


/// atxHeading1 = "#", space, textualContent, atxClosingSequence;
let atxHeading1 = BlockNode.h1 <^> (string("#") *> space *> textualContent <* space.many.optional <* lineEnding)

/// atxHeading2 = "##", space, textualContent, atxClosingSequence;
let atxHeading2 = BlockNode.h2 <^> (string("##") *> space *> textualContent <* space.many.optional <* lineEnding)

/// atxHeading3 = "###", space, textualContent, atxClosingSequence;
let atxHeading3 = BlockNode.h3 <^> (string("###") *> space *> textualContent <* space.many.optional <* lineEnding)

/// atxHeading4 = "####", space, textualContent, atxClosingSequence;
let atxHeading4 = BlockNode.h4 <^> (string("####") *> space *> textualContent <* space.many.optional <* lineEnding)

/// atxHeading5 = "#####", space, textualContent, atxClosingSequence;
let atxHeading5 = BlockNode.h5 <^> (string("#####") *> space *> textualContent <* space.many.optional <* lineEnding)

/// atxHeading6 = "######", space, textualContent, atxClosingSequence;
let atxHeading6 = BlockNode.h6 <^> (string("######") *> space *> textualContent <* space.many.optional <* lineEnding)

/// atxHeading = atxHeading1 | atxHeading2 | atxHeading3 | atxHeading4 | atxHeading5 | atxHeading6;
let atxHeading = atxHeading1 <|> atxHeading2 <|> atxHeading3 <|> atxHeading4 <|> atxHeading5 <|> atxHeading6

/// blankLines = blankLine, {blankLine};
let blankLines = { BlockNode.blankLines($0.count) } <^> blankLine.many

/// indentedChunk = (4 * space, {space}, nonBlankLine), {(4 * space, {space}, nonBlankLine)};
let indentedChunk =  BlockNode.indentedChunk <^> (space.amount(4) *> space.many.optional *> nonBlankLine).many

/// indentedCodeBlock = blankLine, (indentedChunk, blankLine), {(indentedChunk, blankLine)};
let indentedCodeBlock =  BlockNode.indentedCodeBlock <^> (blankLine *> (indentedChunk <* blankLine).many)

/// fencedCodeBlock = ("```", [infoString], lineEnding,
///    {line},
/// "```", lineEnding);
let fencedCodeBlock = curry(BlockNode.fencedCodeBlock) <^> (string("```") *> textualContent.optional <* lineEnding) <*>
                    line.except(string("```")).many.optional <* string("```") <* lineEnding

/// paragraph = inlineLine, {inlineLine};
let paragraph = BlockNode.paragraph <^> inlineLine.many

// leafBlock = thematicBreak | atxHeading | indentedCodeBlock | fencedCodeBlock | linkReferenceDefinition | paragraph | blankLines;
let leafBlock = MarkdownNode.leaf <^> (thematicBreak <|> atxHeading <|> indentedCodeBlock <|> fencedCodeBlock <|> paragraph <|> blankLines)

