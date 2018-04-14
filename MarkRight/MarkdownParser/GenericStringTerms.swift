//
//  GenericStringTerms.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/*********************************************
 **********  Generic String Terms  ***********
 ********************************************/

typealias MDParser<T> = Parser<Substring, T>

func not<T>(_ parser: MDParser<T>) -> MDParser<Substring> {
    
    return MDParser<Substring> {
        input in
        var chs = [Character]()
        var remainder = input
        while let first = remainder.first, case .fail = parser.parse(remainder) {
            chs.append(first)
            remainder = remainder.dropFirst()
        }
        return .done(remainder, Substring(chs))
    }
}

func stringExcept(_ chs: [Character]) -> MDParser<String> {
    
    return { String($0) } <^> character { !chs.contains($0) }.many1
}

/// 换行符

/// newline = U+000A;
let newLine = character { $0 == "\n" }

/// 回车
/// carriageReturn = U+000D;
let carriageReturn = character { $0 == "\r" }

/// 行尾
/// lineEnding = newline | carriageReturn;
let lineEnding = newLine <|> carriageReturn

/// 空格
/// space = U+0020;
let space = character { $0 == " " }

/// TAB：水平制表符
/// tab = U+0009;
let tab = character { $0 == "\t" }

/// 空白行
/// {(space | tab)}, lineEnding;
let blankLine = (space <|> tab).many.followed(by: lineEnding)

/// 垂直制表
/// lineTabulation = U+000B;
let lineTabulation = character { $0 == "\u{000B}" }

/// 换页符
/// formFeed = U+000C;
let formFeed = character { $0 == "\u{000C}" }

/// 空白字符
/// whitespaceCharacter = newline | carriageReturn | space | tab | lineTabulation | formFeed;
let whiteSpaceCharacter = newLine <|> carriageReturn <|> space <|> tab <|> lineTabulation <|> formFeed

/// 空白区域
/// whitespace = whitespaceCharacter, {whitespaceCharacter};
let whiteSpace = { String($0) } <^> whiteSpaceCharacter.many1

///  (*any code point in the Unicode Zs class*) | tab | carriageReturn | newline | formFeed;
let unicodeWhitespaceCharacter = character { CharacterSet.whitespaces.contains($0) }

/// unicodeWhitespace = unicodeWhitespaceCharacter, {unicodeWhitespaceCharacter};
let unicodeWhitespace = { String($0)} <^> unicodeWhitespaceCharacter.many1

/// nonWhitespaceCharacter = (*any character that is not a whitespaceCharacter*);
let nonWhitespaceCharacter = character { !CharacterSet.whitespacesAndNewlines.contains($0) }


/// asciiPunctuationCharacter = "!" | '"' | "#" | "$" | "%" | "&" | "'" | "(" | ")" | "*" | "+" | "," | "-" | "." | "/" | ":" | ";" | "<" | "=" | ">" | "?" | "@" | "[" | "\\" | "]" | "^" | "_" | "`" | "{" | "|" | "}" | "~";
let asciiPunctuationCharacter = character {
    "!|#$%&'()*+,-./:;<=>?@[\\]^_`{|}~".contains($0)
}


/// punctuationCharacter = asciiPunctuationCharacter | (*anything in the Unicode Classes Pc, Pd, Pe, Pf, Pi, Po, Ps*)
let punctuationCharacter = asciiPunctuationCharacter <|> character {
    
    NSCharacterSet.punctuationCharacters.contains($0)
}

/// characterWithoutLinebreak = (*Unicode code point except newline (U+000A) and carriage return (U+000D)*);
let characterWithoutLinebreak = character { $0 != "\n" && $0 != "\r" }

/// nonBlankLine = nonWhitespaceCharacter, {characterWithoutLinebreak}, lineEnding;
private func nonBlankLineJoiner(ch: Character, s: [Character]?, e: Character) -> String {
    
    return String([ch] + (s ?? []) + [e])
}

let nonBlankLine = curry(nonBlankLineJoiner) <^> nonWhitespaceCharacter <*> characterWithoutLinebreak.many <*> lineEnding

let line = { String($0) } <^> character { $0 != "\n" && $0 != "\r" }.many <* lineEnding



