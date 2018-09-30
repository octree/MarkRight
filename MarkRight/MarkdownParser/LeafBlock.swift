//
//  LeafBlock.swift
//  MarkRight
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 **********   Leaf Block Parser   ***********
 ********************************************/

/// thematicBreak = (3 * "-"), {-}, {space}, lineEnding;
private let hyphen = character { $0 == "-" }
let thematicBreak = { _ in return BlockNode.thematicBreak } <^> hyphen.repeat(3).followed(by: string("-").many).followed(by: space.many).followed(by: lineEnding)


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


/************************************ MARKDOWN TABLE ******************************************/

private let tableSep = character { $0 == "|" }


private let tableData = space.many *> (not(tableSep <|> lineEnding) >>- {
        substring in
        return MDParser<[InlineNode]> {
            
            guard case let .done(_, nodes) = inlineWithoutLineBreak.many.parse(substring) else {
                return .fail(ParserError.notMatch)
            }
            return .done($0, nodes)
        }
    }) <* space.many

private let colon = character { $0 == ":" }
private typealias TableDataNodeGen = (TableDataAlignment) -> ([InlineNode]) -> BlockNode

private func alignmentApply(_ any: Any, align: TableDataAlignment) -> (TableDataNodeGen) -> ([InlineNode]) -> BlockNode {
    
    return {
        f in
        return f(align)
    }
}

private let centerAlignmentData = { alignmentApply($0, align: .center ) } <^> (space.many *> colon *>  hyphen.many1 *> colon *> space.many *> tableSep.lookAhead)

private let leftAlignmentData = { alignmentApply($0, align: .left ) } <^> (space.many *> colon.optional *> hyphen.many1 *> space.many *> tableSep.lookAhead)

private let rightAlignmentData = { alignmentApply($0, align: .right ) } <^> (space.many *> hyphen.many1 *> colon *> space.many *> tableSep.lookAhead)

private let tableRow = tableSep *> (curry({ x, y in [x] + y}) <^> (tableData <* tableSep)  <*> (tableData <* tableSep).many1) <* space.many <* lineBreak

private func specificAmountTableRow(_ n: Int) -> MDParser<[[InlineNode]]> {
    
    return tableSep *> (tableData <* tableSep).repeat(n) <* space.many <* lineBreak
}

private func specificAmountDelimiterRow(_ n: Int) -> Parser<Substring, [(TableDataNodeGen) -> ([InlineNode]) -> BlockNode]> {

    let delimiterItem = leftAlignmentData <|> centerAlignmentData <|> rightAlignmentData
    return tableSep *> (delimiterItem <* tableSep).repeat(n) <* space.many <* lineBreak
}

private func tableRowApply(f: TableDataNodeGen,fs: [(TableDataNodeGen) -> ([InlineNode]) -> BlockNode],row: [[InlineNode]]) -> BlockNode {
    let count = fs.count
    let datas = (0 ..< count).map { fs[$0](f)(row[$0]) }
    return BlockNode.tableRow(datas)
}

private func tableRowsApply(f: TableDataNodeGen,fs: [(TableDataNodeGen) -> ([InlineNode]) -> BlockNode],rows: [[[InlineNode]]]) -> [BlockNode] {
    
    return rows.map { tableRowApply(f: f, fs: fs, row: $0) }
}

private func tableGen(headingRow: [[InlineNode]], fs: [(TableDataNodeGen) -> ([InlineNode]) -> BlockNode],rows: [[[InlineNode]]]) -> BlockNode {
    
    let headingRow = tableRowApply(f: curry(BlockNode.tableHeading), fs: fs, row: headingRow)
    return BlockNode.table(headingRow, tableRowsApply(f: curry(BlockNode.tableData), fs: fs, rows: rows))
}

private let table = tableRow >>- {
    row in
    
    return curry(tableGen)(row) <^> specificAmountDelimiterRow(row.count) <*> specificAmountTableRow(row.count).many1
}

/************************************ MARKDOWN TABLE ******************************************/


/// paragraph = inlineLine, {inlineLine};
private let specialLeaf = table <|> thematicBreak <|> atxHeading <|> indentedCodeBlock <|> fencedCodeBlock <|> blankLines
let paragraph = BlockNode.paragraph <^> inlineLine.difference(specialLeaf).difference(containerBlock).many1

// leafBlock = thematicBreak | atxHeading | indentedCodeBlock | fencedCodeBlock | linkReferenceDefinition | paragraph | blankLines;

let leafBlock = MarkdownNode.leaf <^> ( specialLeaf <|> paragraph )

