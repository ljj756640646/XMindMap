//
//  XContentView.swift
//  XMindMap
//
//  Created by 陆俊杰 on 2020/7/26.
//  Copyright © 2020 lujunjie. All rights reserved.
//

import UIKit

class XContentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var vc:UIViewController?
    var rightArray:NSMutableArray!
    var leftArray:NSMutableArray!
    
    
    lazy var rootButton:UIButton = {
        let rootButton = UIButton(type: .custom)
        rootButton.tag = 1000
        rootButton.setTitleColor(UIColor.white, for: .normal)
        rootButton.backgroundColor = UIColor.red
        rootButton.layer.cornerRadius = 8
        return rootButton
    }()
    
    lazy var leftView:XLeftView = {
        let leftView = XLeftView()
        return leftView
    }()
    
    lazy var rightView:XRightView = {
        let rightView = XRightView()
        return rightView
    }()
    
    func draw(node:XNode,leftArray:NSMutableArray,rightArray:NSMutableArray) -> Void {
        
        self.leftArray = leftArray
        self.rightArray = rightArray
        // 添加根节点
        self.addSubview(self.rootButton)
        self.rootButton.setTitle(node.title, for: .normal)
        self.rootButton.sizeToFit()
        
        
        //self.leftView.backgroundColor = UIColor.red
        self.leftView.nodeArray = leftArray
        self.leftView.reloadData()
        self.addSubview(leftView)
        
        
        
        
        //self.rightView.backgroundColor = UIColor.yellow
        self.rightView.nodeArray = rightArray
        self.rightView.reloadData()
        self.addSubview(rightView)
        
        
        var height = 0.0
        if (rightView.frame.size.height > leftView.frame.size.height){
            height = Double(rightView.frame.size.height)
        }else{
            height = Double(leftView.frame.size.height)
        }
        let width = self.rightView.contentWidth + self.leftView.contentWidth + Double(self.rootButton.frame.size.width) + 50
        self.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        let centerX = CGFloat(width)/2
        let centerY = CGFloat(height)/2
        
        self.rootButton.center = CGPoint(x:centerX , y: centerY)
        
        
        
        self.rightView.frame = CGRect(x: self.rootButton.frame.origin.x + self.rootButton.frame.size.width, y: self.rootButton.center.y - ( rightView.frame.size.height/2) , width: rightView.frame.size.width, height: rightView.frame.size.height)
        
        self.leftView.frame = CGRect(x: self.rootButton.frame.origin.x - 1000, y: self.rootButton.center.y - ( leftView.frame.size.height/2) , width: leftView.frame.size.width, height: leftView.frame.size.height)
        
        
        
        // 增删改查
        self.rightView.completeClosure = { [weak self](sender) in
            self?.alertAction(sender: sender)
        }
        self.leftView.completeClosure = { [weak self](sender) in
            self?.alertAction(sender: sender)
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
