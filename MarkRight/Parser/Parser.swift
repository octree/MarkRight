//
//  Parser.swift
//  ParserCombinator
//
//  Created by Octree on 2018/4/13.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

public struct Parser<T> {
    typealias Stream = Substring
    
    let parse: (Stream) -> Reply<Stream, T>
}

// Functor

public extension Parser {
    
    public static func unit(_ x: T) -> Parser<T> {
        
        return Parser { .done($0, x) }
    }
    
    public static var ignore: Parser<()> {
        
        return Parser<()>.unit(())
    }
    
//    Functor
    public func map<U>(_ f: @escaping (T) -> U) -> Parser<U> {
        
        return Parser<U> { self.parse($0).map(f) }
    }
    
    
//    Monad
    public func then<U>(_ f: @escaping (T) -> Parser<U>) -> Parser<U> {
        
        return Parser<U> {
            
            switch self.parse($0) {
            case let .done(remainder, out):
                return f(out).parse(remainder)
            case let .fail(e):
                return .fail(e)
            }
        }
    }
    
//    Applicative
    public func apply<U>(_ mf: Parser<(T) -> U>) -> Parser<U> {
        
        return mf.then(map)
    }
}
