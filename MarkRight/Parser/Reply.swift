//
//  Reply.swift
//  ParserCombinator
//
//  Created by Octree on 2018/4/13.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

public enum Reply<In, Out> {
 
    case done(In, Out)
    case fail(Error)
}


public extension Reply {
    
    public func map<U>(_ f: (Out) -> U) -> Reply<In, U> {
        
        switch self {
        case let .done(inv, out):
            return .done(inv, f(out))
        case let .fail(e):
            return .fail(e)
        }
    }
    
    public func then<U>(_ f: (Out) -> Reply<In, U>) -> Reply<In, U> {
        
        switch self {
        case let .done(_, out):
            return f(out)
        case let .fail(error):
            return .fail(error)
        }
    }
    
    public func apply<U>(_ mf: Reply<In, (Out) -> U>) -> Reply<In, U> {
        
        return mf.then(map)
    }
}

public func <^><A, B, In>(lhs: (A) -> B, rhs: Reply<In, A>) -> Reply<In, B> {
    
    return rhs.map(lhs)
}

public func >>-<A, B, In>(lhs: Reply<In, A>, rhs: (A) -> Reply<In, B>) -> Reply<In, B> {
    
    return lhs.then(rhs)
}

public func <*><A, B, In>(lhs: Reply<In, (A) -> B>, rhs: Reply<In, A>) -> Reply<In, B> {
    
    return rhs.apply(lhs)
}
