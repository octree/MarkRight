//
//  Parser+Extension.swift
//  ParserCombinator
//
//  Created by Octree on 2018/4/13.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


public extension Parser {
    
//    just fail
    public static var fail: Parser<T> {
        return Parser<T> {
            _ in
            return .fail(ParserError.any)
        }
    }
    
    ///  执行 parse，但是不会改变 input
    public var lookAhead: Parser<T> {

        return Parser<T> {
            let reply = self.parse($0)
            switch reply {
            case let .done(_, out):
                return .done($0, out)
            case .fail:
                return reply
            }
        }
    }
    
//    many, maybe empty
    public var many: Parser<[T]> {
        
        return Parser<[T]> {
            input in
            
            var result: [T] = []
            var remainder = input
            
            while case let .done(r, out) = self.parse(remainder) {
                
                result.append(out)
                remainder = r
            }
            return .done(remainder, result)
        }
    }
    
    
// many, as leat 1
    
    public var many1: Parser<[T]> {
        
        return curry({ x, y in [x] + y }) <^> self <*> many
    }
    
    public var skipMany: Parser<()> {
        
        return many *> .ignore
    }
    
    public var skipMany1: Parser<()> {
        
        return many1 *> .ignore
    }
    
    
//    optional
    public var optional: Parser<T?> {
        return Parser<T?> {
            
            switch self.parse($0) {
            case let .done(remainder, out):
                return .done(remainder, out)
            case .fail(_):
                return .done($0, nil)
            }
        }
    }
    
    public func otherwise(_ v: T) -> Parser<T> {
        
        return self <|> .unit(v)
    }
    
//    差集
    public func difference<U>(_ other: Parser<U>) -> Parser<T> {
        
        return Parser<T> {
            
            if case .done(_) = other.parse($0) {
                return .fail(ParserError.notMatch)
            }
            return self.parse($0)
        }
    }
    
    public func followed<U>(by other: Parser<U>) -> Parser<(T, U)> {
        
        return curry({ x, y in (x, y) }) <^> self <*> other
    }
    
    public func `repeat`(_ n: Int) -> Parser<[T]> {
        
        return Parser<[T]> {
            
            var result = [T]()
            var remainder = $0
            for _ in 0 ..< n {
                
                guard case let .done(r, out) = self.parse(remainder) else {
                    return .fail(ParserError.notMatch)
                }
                remainder = r
                result.append(out)
            }
            return .done(remainder, result)
        }
    }
    
    
    public func sep<U>(by other: Parser<U>) -> Parser<[T]> {
        
        return sep1(by: other) <|> .unit([])
    }
    
    public func sep1<U>(by other: Parser<U>) -> Parser<[T]> {
        
        return curry({ [$0] + $1 }) <^> self <*>  (other *> self).many
    }
    
    public func end<U>(by other: Parser<U>) -> Parser<[T]> {
        
        return many <* other
    }
    
    public func end1<U>(by other: Parser<U>) -> Parser<[T]> {
        
        return many1 <* other
    }
    
///   separated and optionally ended by sep
///   EBNF: (p (sep p)* sep?)?
    public func sepEnd<U>(by other: Parser<U>) -> Parser<[T]> {
        
        return sep1(by: other) <|> .unit([])
    }
///   separated and optionally ended by sep
///   EBNF: p (sep p)* sep?
    public func sepEnd1<U>(by other: Parser<U>) -> Parser<[T]> {
        
        return sep1(by: other) <* other.optional
    }
    
    public func many<U>(till other: Parser<U>) -> Parser<[T]> {
        
        return difference(other).many
    }
    
    public func many1<U>(till other: Parser<U>) -> Parser<[T]> {
        
        return difference(other).many1
    }
    
    public func between<U, V>(open: Parser<U>, close: Parser<V>) -> Parser<T> {
        
        return open *> self <* close
    }
    
    
    /// self (op self)*
    /// 可以用来消除左递归
    ///
    /// - Parameter op: op parser
    /// - Returns: parser
    public func chainl1(op: Parser<(T, T) -> T>) -> Parser<T> {

        func f(_ lhs: T) -> Parser<T> {
            
            let parser = op >>- {
                opf in
                self >>- { rhs in f(opf(lhs, rhs)) }
            }
            return parser <|> .unit(lhs)
        }
        
        return self >>- f
    }
    
    
    public func chainr1(op: Parser<(T, T) -> T>) -> Parser<T> {
        
        func scan() -> Parser<T> {
            
            return self >>- f
        }
        
        func f(_ lhs: T) -> Parser<T> {
            
            let parser: Parser<T> = op >>- { opf in
                scan() >>- { rhs in
                    return Parser<T>.unit(opf(lhs, rhs))
                }
            }
            return parser <|> .unit(lhs)
        }
        
        return scan()
    }
    
}


