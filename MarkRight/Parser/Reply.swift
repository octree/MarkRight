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
}
