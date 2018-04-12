//
//  MarkdownNode+HTML.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension MarkdownNode: HTMLConversionProtocol {
    
    var htmlText: String {
        
        switch self {
        case .leaf(let l):
            return l.htmlText
        case .container(let c):
            return c.htmlText
        }
    }
}
