//
//  XView.swift
//  XMindMap
//
//  Created by 陆俊杰 on 2020/7/25.
//  Copyright © 2020 lujunjie. All rights reserved.
//

import UIKit

class XView: UIView {

    
    public var completeClosure: ((XButton) -> (Void))?
    
    var defaultHeight = 50.0  // 每个节点按钮的高度
    var defaultSpace = 50.0   // 横向按钮间的距离
    var leafCount = 0.0      // right 共有多少个叶子节点
    var contentHeight = 0.0     // right 总高度
    var contentWidth = 0.0      // 内容高度
    var nodeArray:NSMutableArray!

    
    func resetNode() -> Void {
        self.leafCount = 0.0
        self.contentHeight = 0.0
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    
    
    
    /// 初始化设置节点、获取叶子节点数据
    ///
    /// - Parameters:
    ///   - array: 节点数组
    ///   - index: 深度
    ///   - type: 0 right 1 left
    func initData(array:NSMutableArray,index:Int,type:Int)  {
        
        // 设置兄弟节点
        var tempNode:XNode!
        var i = 0
        for node in array{
            if let node:XNode = node as? XNode {
                if i == 0{
                    tempNode = node
                }else{
                    node.previousNode = tempNode
                    tempNode = node
                }
                node.index = i
            }
            i += 1
        }
        
        
        
        for node in array{
            
            if let node:XNode = node as? XNode {
                node.siblingCount = Double(array.count)
                node.level = index
                print("---深度=" + String(index) + "----index=" + String(node.index) + "----count=" + String(node.siblingCount))
                print(node.title)
                
                
                if let array:NSMutableArray = node.children?.attached{
                    if array.count > 0 {
                        var index1 = index
                        index1 += 1
                        // 设置父节点
                        let superNode:XNode = node
                        for node in array{
                            if let node:XNode = node as? XNode {
                                node.superNode = superNode
                            }
                        }
                        var tempNode:XNode? = node.superNode
                        var path = String(node.index)
                        while(tempNode != nil){
                            if let tempNode = tempNode{
                                path = String(tempNode.index) + "-" + path
                            }
                            tempNode = tempNode?.superNode
                        }
                        node.path = path
                        print("path = " + path)
                        self.initData(array: array,index: index1,type:type)
                    }else{
                        // 设置各个子节点对应的最大叶子节点个数
                        self.initLeafData(node: node, type: type)
                    }
                }else
                {
                    // 设置各个子节点对应的最大叶子节点个数
                    self.initLeafData(node: node, type: type)
                }
            }
            
        }
        
    }
    
    /// // 设置各个子节点对应的最大叶子节点个数
    /// - Parameters:
    ///   - node: 叶子节点
    ///   - type: right left
    func initLeafData(node:XNode,type:Int) -> Void {
        
        var superNode = node.superNode
        if superNode == nil{
            node.maxChildrenCount = 1
        }
        var path = String(node.index)
        while(superNode != nil){
            if let superNode = superNode{
                path = String(superNode.index) + "-" + path
            }
            if ((superNode?.superNode) != nil){
                if (superNode?.children?.attached.count)! > 1{
                    superNode?.maxChildrenCount += 1
                }
                if superNode?.superNode != nil{
                    if (superNode?.superNode?.children?.attached.count)! <= 1{
                        superNode?.superNode?.maxChildrenCount = (superNode?.maxChildrenCount)!
                    }
                }
                superNode = superNode?.superNode
            }else{
                superNode?.maxChildrenCount += 1
                superNode = superNode?.superNode
            }
        }
        node.path = path
        print("path = " + path)
        self.leafCount += 1
        
        
    }
    
    /// 绘制right节点
    ///
    /// - Parameters:
    ///   - array: 节点数组
    ///   - index: 1
    ///   - type: 0 right 1 left
    func drawNodes(array:NSMutableArray,index:Int,type:Int) -> Void {
        for node in array{
            
            if let node:XNode = node as? XNode {
                let nodeBtn = self.getButton(id: node.id, index: index,type: type)
                nodeBtn.path = node.path
                nodeBtn.setTitle(node.title, for: .normal)
                var height = 0.0// 每个按钮分配的高度
                if index == 1{
                    self.addSubview(nodeBtn)
                    nodeBtn.sizeToFit()
                    height = Double(self.defaultHeight * node.maxChildrenCount) // 当前node高度
                    node.nodeBtn_height = Double(height)
                    var y_height = 0.0 // y + height 高度
                    var y = 0
                    if node.previousNode == nil{
                        y_height = height
                        y = 0
                    }else{
                        y_height = Double(Int((node.previousNode?.nodeBtn_y_height)!) + Int(height))
                        y = Int(y_height - height)
                    }
                    node.nodeBtn_y_height = Double(y_height) // 保存 y + height 高度
                    node.nodeBtn_y = Double(y) // 保存y
                    
                    let centerY = y_height - (height/2) // 按钮 centerY
                    var x = 0.0
                    if type == 0{
                        //x = Double(self.rootButton.frame.origin.x + self.rootButton.frame.size.width)  + defaultSpace
                        x = 0 + defaultSpace
                    }else{
                        //x = Double(self.rootButton.frame.origin.x - nodeBtn.frame.size.width)  - defaultSpace
                        x = Double(self.frame.size.width - nodeBtn.frame.size.width) - defaultSpace
                    }
                    
                    nodeBtn.center = CGPoint(x: x, y: centerY)
                    nodeBtn.frame = CGRect(x: CGFloat(x), y: nodeBtn.frame.origin.y, width: nodeBtn.frame.size.width, height: nodeBtn.frame.size.height)
                    
                }else{
                    self.addSubview(nodeBtn)
                    nodeBtn.sizeToFit()
                    
                    
                    if node.maxChildrenCount > 1 {
                        height = (node.superNode?.nodeBtn_height)!/(node.superNode?.maxChildrenCount)! * node.maxChildrenCount
                        
                    }else{
                        var maxCount = 0.0
                        if node.superNode?.maxChildrenCount == 0{
                            maxCount = 1
                        }else{
                            maxCount = (node.superNode?.maxChildrenCount)!
                        }
                        height = (node.superNode?.nodeBtn_height)!/maxCount //平均每个按钮分配高度
                    }
                    node.nodeBtn_height = height
                    
                    
                    var y_height = 0.0
                    var y_ = 0.0
                    if node.previousNode == nil{
                        y_height =  (node.superNode?.nodeBtn_y)! + height
                        y_ = y_height - height
                    }else{
                        y_height = (node.previousNode?.nodeBtn_y_height)! + height //
                        y_ = y_height - height
                    }
                    node.nodeBtn_y_height = y_height
                    node.nodeBtn_y = y_
                    let centerY = y_height - (height/2)
                    var x = 0.0
                    if type == 0{
                        x = (node.superNode?.nodeBtn_x_width)!  + defaultSpace
                    }else{
                        x = (node.superNode?.nodeBtn_x)! - Double(nodeBtn.frame.size.width)  - defaultSpace
                    }
                    
                    nodeBtn.center =  CGPoint(x: x, y: centerY)
                    nodeBtn.frame = CGRect(x: CGFloat(x), y: nodeBtn.frame.origin.y, width: nodeBtn.frame.size.width, height: nodeBtn.frame.size.height)
                    
                }
                if let array:NSMutableArray = node.children?.attached{
                    
                    var index1 = index
                    index1 += 1
                    for node in array{
                        if let node:XNode = node as? XNode {
                            node.superNode?.nodeBtn_x_width = Double(nodeBtn.frame.origin.x + nodeBtn.frame.size.width)
                            node.superNode?.nodeBtn_x = Double(nodeBtn.frame.origin.x)
                            //node.superNode?.nodeBtn_height = height
                        }
                    }
                    self.drawNodes(array: array,index: index1,type: type)
                }else
                {
                    
                    if type == 0{
                        // 叶子节点
                        let right = nodeBtn.frame.origin.x + nodeBtn.frame.size.width
                        if Double(right) > self.contentWidth{
                            self.contentWidth = Double(right)
                        }
                    }else{
                        // 叶子节点
                        let left = 1000 -  nodeBtn.frame.origin.x
                        if Double(left) > self.contentWidth{
                            self.contentWidth = Double(left)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    
    
    /// 获取按钮
    /// - Parameters:
    ///   - id: node id
    ///   - index: index
    ///   - level: 深度
    ///   - type: type
    func getButton(id:String,index:Int,type:Int) -> XButton {
        
        let nodeBtn = XButton(type: .custom)
        nodeBtn.setTitleColor(UIColor.white, for: .normal)
        nodeBtn.backgroundColor = getRandomColor()
        nodeBtn.layer.cornerRadius = 8
        nodeBtn.id = id
        nodeBtn.type = type
        nodeBtn.tag = type
        if nodeBtn.path.count > 0 {
            nodeBtn.path = nodeBtn.path + "," + String(index)
        }else{
            nodeBtn.path = String(index)
        }
        nodeBtn.addTarget(self, action: #selector(alertAction(sender:)), for: .touchUpInside)
        return nodeBtn
    }
    func getRandomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 256)/256.0
        let saturation = CGFloat(arc4random() % 128) / 256.0 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256.0  + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1);
    }

    @objc func alertAction(sender:XButton) -> Void {
        
        if let completeClosure = self.completeClosure{
            completeClosure(sender)
        }
    }
}
