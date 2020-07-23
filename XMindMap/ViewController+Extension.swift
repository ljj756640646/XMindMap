
//
//  ViewController+Extension.swift
//  XMindMap
//
//  Created by lujunjie on 2020/7/22.
//  Copyright © 2020 lujunjie. All rights reserved.
//

import Foundation
import UIKit
extension ViewController{
    
    
    /// 弹框
   @objc func alertAction(sender:XButton) -> Void {
       let alertVc = UIAlertController(title: "管理【" + (sender.titleLabel?.text)! + "】", message: "", preferredStyle: .alert)
       let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
           
       }
       alertVc.addAction(cancleAction)
       let deleteAction = UIAlertAction(title: "删除", style: .default) { (action) in
           sender.removeFromSuperview()

           if sender.type == 0{
               self.deleteAction(array: self.rightArray,id: sender.id,path: sender.path,type: sender.type)
           }else{
               self.deleteAction(array: self.leftArray,id: sender.id,path: sender.path,type: sender.type)
           }
           
       }
       alertVc.addAction(deleteAction)
    
      let addAction = UIAlertAction(title: "添加子节点", style: .default) { (action) in
          
      }
      alertVc.addAction(addAction)
    
      let editAction = UIAlertAction(title: "修改节点", style: .default) { (action) in
        
      }
      alertVc.addAction(editAction)
       
       self.present(alertVc, animated: true, completion: nil)
   }
    /// 删除节点
    /// - Parameters:
    func deleteAction(array:NSMutableArray,id:String,path:String,type:Int) -> Void {
        var strArray = path.components(separatedBy: "-")
        let index:String = strArray[0]
        let node = array[Int(index)!]
        if let node:XNode = node as? XNode {
            if node.id == id {
                array.removeObject(at: Int(index)!)
                if type == 0 {
                    // 也可以直接遍历删除
                    self.resetData(array: self.rightArray, index: 1,type: 0)
                    self.resetRight()
                    self.drawRight()
                }else{
                    self.resetData(array: self.leftArray, index: 1,type: 1)
                    self.resetLeft()
                    self.drawLeft()
                }
                
                return
            }else
            {
                if let array:NSMutableArray = node.children?.attached{
                    strArray.removeFirst()
                    let str = strArray.joined(separator: "-")

                    self.deleteAction(array: array, id: id, path: str,type: type)
                }

            }
        }
        
    }
    func addAction(node:XNode,array:NSMutableArray,id:String,path:String,type:Int) -> Void {
        var strArray = path.components(separatedBy: "-")
        let index:String = strArray[0]
        let dNode = array[Int(index)!]
        if let dNode:XNode = dNode as? XNode {
            if dNode.id == id {
                array.removeObject(at: Int(index)!)
                if type == 0 {
                    // 也可以直接遍历删除
                    self.resetData(array: self.rightArray, index: 1,type: 0)
                    self.resetRight()
                    self.drawRight()
                }else{
                    self.resetData(array: self.leftArray, index: 1,type: 1)
                    self.resetLeft()
                    self.drawLeft()
                }
                
                return
            }else
            {
                if let array:NSMutableArray = dNode.children?.attached{
                    strArray.removeFirst()
                    let str = strArray.joined(separator: "-")

                    self.addAction(node:node,array: array, id: id, path: str,type: type)
                }

            }
        }
    }
      /// 初始化设置节点、获取叶子节点数据
      ///
      /// - Parameters:
      ///   - array: 节点数组
      ///   - index: 深度
      ///   - type: 0 right 1 left
      func resetData(array:NSMutableArray,index:Int,type:Int)  {
    
          for node in array{

              if let node:XNode = node as? XNode {
                  node.reset()
                  if let array:NSMutableArray = node.children?.attached{
                      var index1 = index
                      index1 += 1
                      self.resetData(array: array,index: index1,type:type)
                      
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
//          nodeBtn.index = index
          //nodeBtn.level = level
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
}
