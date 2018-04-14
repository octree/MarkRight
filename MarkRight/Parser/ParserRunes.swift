//
//  ParserRunes.swift
//  ParserCombinator
//
//  Created by Octree on 2018/4/13.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

/// Functor Operator
/// a -> b -> m a -> m b
public func <^><Stream, A, B>(lhs: @escaping (A) -> B, rhs: Parser<Stream, A>) -> Parser<Stream, B> {
    return rhs.map(lhs)
}


/// Monad
///  m a -> (a -> m b) -> m b
public func >>-<Stream, A, B>(lhs: Parser<Stream, A>, rhs: @escaping (A) -> Parser<Stream, B>) -> Parser<Stream, B> {
    
    return lhs.then(rhs)
}


/// applicative
/// m (a -> b) -> m a -> m b
public func <*><Stream, A, B>(lhs: Parser<Stream, (A) -> B>, rhs: Parser<Stream, A>) -> Parser<Stream, B> {
    
    return rhs.apply(lhs)
}

/// Ignoring Left
/// ma -> mb -> mb
public func *><Stream, A, B>(lhs: Parser<Stream, A>, rhs: Parser<Stream, B>) -> Parser<Stream, B> {
    
    return curry({ _, y in y }) <^> lhs <*> rhs
}


/// Ignoring Right
/// ma -> mb -> ma
public func <*<Stream, A, B>(lhs: Parser<Stream, A>, rhs: Parser<Stream, B>) -> Parser<Stream, A> {
    
    return curry({ x, _ in x }) <^> lhs <*> rhs
}


/// or
/// m a -> m a -> m a
public func <|><Stream, A>(lhs: Parser<Stream, A>, rhs: Parser<Stream, A>) -> Parser<Stream, A> {
    
    return Parser {
        
        let result = lhs.parse($0)
        switch result {
        case .done(_):
            return result
        default:
            return rhs.parse($0)
        }
    }
}

