//
//  XMindNode.swift
//  XMind
//
//  Created by 陆俊杰 on 2020/7/7.
//  Copyright © 2020 陆俊杰. All rights reserved.
//

import Foundation


// 存储对象
class XAttachedModel {
    var attached:NSMutableArray = NSMutableArray()
    init(dic:Dictionary<String, Any>) {
        let array:Array<Any> = dic["attached"] as! Array
        //var index = 0
        for dic in array{
            let node = XNode(dic: dic as! Dictionary<String, Any>)
            attached.add(node)
        }
    }
    init() {
        
    }
    
}

// 叶子节点
class XNode {
    var id = ""
    var title = ""
    var index = 0
    var level = 0
    var path = "" // 存储路径
    
    
    var siblingCount = 0.0 // 兄弟节点共有几个
//    var childrenCount = 0.0 // 子节点共有几个
    var maxChildrenCount = 0.0
    
    var children:XAttachedModel?
    var rightNumber:XRightNumber?
    var nodeBtn_x_width = 0.0 // x + width
    var nodeBtn_x = 0.0
    var nodeBtn_y_height = 0.0
    var nodeBtn_y = 0.0
    var nodeBtn_height = 0.0
    var nodeBtn_width = 0.0
    var nodeBtn_centerY = 0.0
    
    
    
    var superNode:XNode?
    var previousNode:XNode?
    
    
    func reset() -> Void {
//        self.id = ""
//        self.title = ""
        self.index = 0
        self.level = 0
        self.path = ""
        self.siblingCount = 0.0
        self.maxChildrenCount = 0.0
//        self.children = nil
        self.rightNumber = nil
        self.nodeBtn_x_width = 0.0 // x + width
        self.nodeBtn_x = 0.0
        self.nodeBtn_y_height = 0.0
        self.nodeBtn_y = 0.0
        self.nodeBtn_height = 0.0
        self.superNode = nil
        self.previousNode = nil

    }
    
    
    init(dic:Dictionary<String, Any>) {
        self.id = dic["id"] as? String ?? ""
        self.title = dic["title"] as? String ?? ""
        if let dic = dic["children"] as? Dictionary<String, Any>{
            self.children = XAttachedModel(dic: dic )
//            self.childrenCount = Double((self.children?.attached.count)!)
        }
        if  let array:Array<Any> = dic["extensions"] as? Array{
            if let dic:Dictionary<String,Any> = array.first as? Dictionary<String, Any>{
                let array:Array<Any> = dic["content"] as! Array
                if let dic:Dictionary<String,Any> = array.first as? Dictionary<String, Any>{
                    self.rightNumber = XRightNumber(dic:dic)
                }
            }
            
            
        }
        
    }
    init(id:String,title:String) {
        self.id = id
        self.title = title
    }
}

// 描述
class XRightNumber {
    var content = ""
    var name = ""
    init(dic:Dictionary<String, Any>) {
        self.content = dic["content"] as? String ?? ""
        self.name = dic["right-number"] as? String ?? ""
    }
}
