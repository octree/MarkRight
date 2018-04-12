//
//  Parser+Extension.swift
//  Pretty
//
//  Created by Octree on 2018/4/7.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


extension Parser {
    
    private var _many: Parser<[Result]> {
        
        return Parser<[Result]> {
            input in
            var result: [Result] = []
            var remainder = input
            
            while let (element, newRemainder) = self.parse(remainder) {
                
                result.append(element)
                remainder = newRemainder
            }
            return (result, remainder)
        }
    }
    
    
    var many: Parser<[Result]> {
        
        return curry { [$0] + $1 } <^> self <*> self._many
    }

    
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> {
        
        return Parser<T> {
            input in
            guard let (result, remainder) = self.parse(input) else {
                return nil
            }
            return (transform(result), remainder)
        }
    }
    
    func then<B>(lhs: @escaping (Result) -> Parser<B>) -> Parser<B> {
        
        return Parser<B> {
            input in
            guard let rt = self.parse(input) else {
                return nil
            }
            
            return lhs(rt.0).parse(rt.1)
        }
    }
    
    func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
        return Parser<(Result, A)>  {
            input in
            
            guard let (first, reminder) = self.parse(input),
                let (second, newReminder) = other.parse(reminder) else {
                    return nil
            }
            return ((first, second), newReminder)
        }
    }
    
    func or(_ other: Parser<Result>) -> Parser<Result> {
        
        return Parser {
            input in
            return self.parse(input) ?? other.parse(input)
        }
    }
    
    var optional: Parser<Result?> {
        
        return Parser<Result?> {
            input in
            guard let (result, remainder) = self.parse(input) else {
                return (nil, input)
            }
            return (result, remainder)
        }
    }
    
    func amount(_ n: Int) -> Parser<[Result]> {
        
        return Parser<[Result]> {
            input in
            
            var result = [Result]()
            var remainder = input
            
            var counter = n
            
            while counter > 0 {
                
                if let (r, newRemainder) = self.parse(remainder) {
                    
                    result.append(r)
                    remainder = newRemainder
                } else {
                    return nil
                }
                counter -= 1
            }
            
            return (result, remainder)
        }
    }
    
    func max(_ n: Int) -> Parser<[Result]> {
        
        return Parser<[Result]> {
            input in
            
            var result = [Result]()
            var remainder = input
            var count = 0
            
            while let (r, newRemainder) = self.parse(remainder), count < n {
                
                result.append(r)
                remainder = newRemainder
                count += 1
            }
            return (result, remainder)
        }
    }
    
    
    func except<A>(_ parser: Parser<A>) -> Parser<Result> {
        
        return Parser<Result> {
            input in
            
            if let _ = parser.parse(input) {
                return nil
            }
            return self.parse(input)
        }
    }
    
}


extension Parser {
    
    var ignoreSpace: Parser<Result> {
        
        return Parser {
            input in
            
            var reminder = input
            
            while reminder.first == " " {
                reminder = reminder.dropFirst()
            }
            
            return self.parse(reminder)
        }
    }
}
