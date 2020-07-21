//
//  NSMutableArray+Extension.swift
//  XMind
//
//  Created by lujunjie on 2020/7/21.
//  Copyright © 2020 陆俊杰. All rights reserved.
//

import Foundation

extension NSMutableArray{
    
    func splitRight(count:Int) -> NSMutableArray {
        let rightSplit = NSMutableArray()
        let half = count

        for i in 0 ..< half{
           let model = self[i]
           rightSplit.add(model)
        }
        
        return rightSplit

    }
    
    func splitLeft(count:Int) -> NSMutableArray {
        let leftSplit = NSMutableArray()
        let ct = self.count
        let half = count

        
        for i in half ..< ct{
           let model = self[i]
            leftSplit.insert(model, at: 0)
        }
        
        return leftSplit

    }
}
