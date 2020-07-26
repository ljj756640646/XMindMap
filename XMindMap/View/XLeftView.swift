//
//  XLeftView.swift
//  XMindMap
//
//  Created by 陆俊杰 on 2020/7/25.
//  Copyright © 2020 lujunjie. All rights reserved.
//

import UIKit

class XLeftView: XView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() -> Void {
        self.resetNode()
        // left
        self.initData(array: self.nodeArray, index: 1, type: 1)
        self.contentHeight = self.leafCount * defaultHeight
        self.bounds = CGRect(x: 0, y: 0, width: 1000, height: self.contentHeight)
        self.drawNodes(array: self.nodeArray, index: 1, type: 1)
    }
}
