//
//  CharacterSet+Extension.swift
//  Pretty
//
//  Created by Octree on 2018/4/7.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    func contains(_ c: Character) -> Bool {
        
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else {
            return false
        }
        return contains(scalars.first!)
    }
}


/// Just parse one character
///
/// - Parameter condition: condition
/// - Returns: Parser<Character>
func character(matching condition: @escaping (Character) -> Bool) -> Parser<Character> {
    
    return Parser(parse: { input in
        guard let char = input.first, condition(char) else {
            return nil
        }
        return (char, input.dropFirst())
    })
}


func string(_ string: String) -> Parser<String> {
    
    return Parser {
        input in
        if input.hasPrefix(string) {
            
            return (string, input.dropFirst(string.count))
        }
        return nil
    }
}

