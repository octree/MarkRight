//
//  MarkdownNode.swift
//  SwiftCMD
//
//  Created by Octree on 2018/4/11.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


indirect enum MarkdownNode {
    
    case container(ContainerNode)
    case leaf(BlockNode)
}
