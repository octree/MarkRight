//
//  InlineLine+HTML.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension Array: HTMLConversionProtocol where Element: HTMLConversionProtocol {
    
    var htmlText: String {
        
        return map { $0.htmlText }.reduce("", +)
    }
    
}
