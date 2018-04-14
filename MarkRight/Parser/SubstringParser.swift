//
//  SubstringParser.swift
//  ParserCombinator
//
//  Created by Octree on 2018/4/13.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

public func character(matching condition: @escaping (Character) -> Bool) -> Parser<Substring, Character> {
    
    return Parser{ input in
        
        guard let ch = input.first else {
            return .fail(ParserError.eof)
        }
        
        guard condition(ch) else {
            return .fail(ParserError.notMatch)
        }
        return .done(input.dropFirst(), ch)
    }
}

public func string(_ text: String) -> Parser<Substring, String> {
    
    return Parser<Substring, String> {
        
        if $0.hasPrefix(text) {
            
            return .done($0.dropFirst(text.count), text)
        }
        return .fail(ParserError.notMatch)
    }
}

