//
//  ViewController.swift
//  XMindMap
//
//  Created by lujunjie on 2020/7/21.
//  Copyright © 2020 lujunjie. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate{

    
    
    
   lazy var scrollView:UIScrollView = {
      let scrollView = UIScrollView()
       scrollView.minimumZoomScale = 0.4
       scrollView.maximumZoomScale = 1
    
       scrollView.delegate = self
       return scrollView
   }()
    
    
    lazy var contentView:XContentView = {
        let contentView = XContentView()
        return contentView
    }()
    
    lazy var saveBtn:UIButton = {
       let saveBtn = UIButton(type: .custom)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(UIColor.black, for:.normal)
        saveBtn.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)
        return saveBtn
    }()
    
   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return self.contentView
   }

   func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scrollW = scrollView.frame.size.width
        let scrollH = scrollView.frame.size.height
        
        let contentSize = scrollView.contentSize
        let offsetX = scrollW > contentSize.width ? (scrollW - contentSize.width) * 0.5 : 0;
        let offsetY = scrollH > contentSize.height ? (scrollH - contentSize.height) * 0.5 : 0;
        
        let centerX = contentSize.width * 0.5 + offsetX;
        let centerY = contentSize.height * 0.5 + offsetY;
        
       
        self.contentView.center =  CGPoint(x: centerX, y: centerY)
    }
    
    
    
    

   override func viewDidLoad() {
       super.viewDidLoad()
       self.view.addSubview(self.scrollView)
       self.scrollView.backgroundColor = UIColor.purple
       self.scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
       if let rootDic = Bundle.fetch() {
           let rootNode = XNode(dic: rootDic)
           self.drawAction(node: rootNode,index: 0)
       }
    
       self.view.addSubview(self.saveBtn)
       self.saveBtn.frame = CGRect(x: 0, y: 20, width: 50, height: 35)
   
   }
       
    @objc func saveAction(sender:UIButton) -> Void {
        UIGraphicsBeginImageContextWithOptions(self.contentView.bounds.size, false, 0.0)
        self.contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(imageAction(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }

    @objc func imageAction(image:UIImage,didFinishSavingWithError: NSError?,contextInfo: AnyObject){
        if didFinishSavingWithError != nil{
            print("保存失败")
        }else{
            print("保存成功")
        }
    }
    

       
   /// 绘制节点
   ///
   /// - Parameters:
   ///   - node: 根节点
   ///   - index: 0
   func drawAction(node:XNode,index:Int) -> Void {
    
    
       if let rightNumber  = node.rightNumber{
           if rightNumber.content.count > 0{
               let count:Int = Int(rightNumber.content)!
               if let array:NSMutableArray = node.children?.attached{

                let rightArray = array.splitRight(count: count)

                let leftArray = array.splitLeft(count: count)
                
                
                
                    self.scrollView.frame = CGRect(x: 0.0, y: 0.0, width: Double(UIScreen.main.bounds.width), height: Double(UIScreen.main.bounds.height))
                    self.scrollView.contentSize = CGSize(width: 2000, height: 2000)
                    self.scrollView.setContentOffset(CGPoint(x: 800, y: 700), animated: true)
                   self.scrollView.addSubview(self.contentView)
                
                
                   self.contentView.center = CGPoint(x: 1000, y: 1000)
                   self.contentView.backgroundColor = UIColor(red: 155, green: 157, blue: 158, alpha: 1)
                   self.contentView.isUserInteractionEnabled = true
                
                  let tapGesture = UITapGestureRecognizer(target: self, action:#selector(handleTapGesture(tap:)))
                   tapGesture.numberOfTapsRequired = 2
                
                    self.contentView.addGestureRecognizer(tapGesture)
                
                    self.contentView.vc = self
                    self.contentView.draw(node: node, leftArray: leftArray, rightArray: rightArray)
                
               }
            
            
           }
        
       }
    
   }
    
    @objc func handleTapGesture(tap:UITapGestureRecognizer) -> Void {
        
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }else{
            let point = tap.location(in: self.scrollView)
            let zoomRect = self.zoomRect(scrollView: self.scrollView, scale: self.scrollView.maximumZoomScale, center: point)
            
            self.scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    

    
    func zoomRect(scrollView:UIScrollView,scale:CGFloat,center:CGPoint) -> CGRect {
        
        var zoomRect:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        zoomRect.size.height = scrollView.frame.size.height/scale
        zoomRect.size.width = scrollView.frame.size.width/scale
        zoomRect.origin.x = center.x / (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
}

