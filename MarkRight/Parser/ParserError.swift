//
//  ParserError.swift
//  ParserCombinator
//
//  Created by Octree on 2018/4/13.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/// Parser 错误信息
///
/// - any: 任意错误
/// - notMatch: 不匹配
/// - eof: 文件结尾
public enum ParserError: Error {
    
    case any
    case notMatch
    case eof
}

