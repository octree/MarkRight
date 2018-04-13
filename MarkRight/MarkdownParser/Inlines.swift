//
//  Inlines.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 **********        Inlines         ***********
 ********************************************/


/// textualContent = characterWithoutLinebreak, {characterWithoutLinebreak};
let textualContent = { String($0) } <^> characterWithoutLinebreak.many1

/// softLineBreak = "\n";
let softLineBreak = String.init <^> character { $0 == "\n" }

/// hardLineBreak = ("  " | "\\"), "\n";
let hardLineBreak = curry({ $0 + $1 }) <^> (string("  ") <|> string("\\")) <*> string("\n")

/// lineBreak = hardLineBreak | softLineBreak;
let lineBreak = hardLineBreak <|> softLineBreak


/// codeSpan = "`", textualContent, "`";
let codeSpan = InlineNode.codeSpan <^> (string("`") *> stringExcept(["\n", "\r", "`"]) <* string("`"))

/// emphasis = "*", textualContent, "*";
let emphasis = InlineNode.emphasis <^> (string("*") *> stringExcept(["\n", "\r", "*"]) <* string("*"))

/// strongEmphasis = "**", textualContent, "**";
let strongEmphasis = InlineNode.strongEmphasis <^> (string("**") *> stringExcept(["\n", "\r", "*"]) <* string("**"))

/// linkText = "[", textualContent, "]";
let linkText = string("[") *> stringExcept(["\n", "\r", "]"]) <* string("]")

/// linkLabel = "[", nonWhitespaceCharacter, 998 * [nonWhitespaceCharacter], "]"

/// (*Second Option*)
//linkDestination = "<", nonWhitespaceCharacter, {nonWhitespaceCharacter}, ">";
let linkDestination = { String($0) } <^> nonWhitespaceCharacter.difference(string(")")).many1

/// inlineLink = linkText, "(", [whitespace], [linkDestination], [whitespace, linkTitle], [whitespace], ")";
let inlineLink = curry(InlineNode.inlineLink) <^> linkText <*> ( string("(") *> linkDestination.optional <* string(")"))

/// imageDescription = "![", textualContent, "]";

let imageDescription = string("![") *> stringExcept(["\n", "\r", "]"]) <* string("]")

/// image = imageDescription, "(", [linkDestination], ")";
let image =  curry(InlineNode.image) <^> imageDescription <*> (string("(") *> linkDestination.optional <* string(")"))

/// inlineWithoutLineBreak = codeSpan | emphasis | strongEmphasis | inlineLink | fullReferenceLink | image | textualContent;


let correctTextualContent = { InlineNode.textualContent(String($0)) } <^> (characterWithoutLinebreak.difference(codeSpan <|> strongEmphasis <|> emphasis <|> inlineLink <|> image)).many1
let inlineWithoutLineBreak = codeSpan <|> strongEmphasis <|> emphasis <|> inlineLink <|> image <|> correctTextualContent

/// inlineLine = inlineWithoutLineBreak, {inlineWithoutLineBreak}, lineBreak;
let inlineLine = inlineWithoutLineBreak.many1 <* lineBreak

