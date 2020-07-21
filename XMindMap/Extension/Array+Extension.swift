//
//  Array+Extension.swift
//  XMind
//
//  Created by 陆俊杰 on 2020/7/15.
//  Copyright © 2020 陆俊杰. All rights reserved.
//

import Foundation

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let rightSplit = self[0 ..< half]
        let leftSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
    
    func split(count:Int) -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = count
        let rightSplit = self[0 ..< half]
        let leftSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
