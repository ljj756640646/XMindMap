//
//  Bundle+Extension.swift
//  XMind
//
//  Created by 陆俊杰 on 2020/7/10.
//  Copyright © 2020 陆俊杰. All rights reserved.
//

import Foundation

extension Bundle{
    static func fetch() -> Dictionary<String,Any>? {
        let path = Bundle.main.path(forResource: "content", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! Array<Any>
            if jsonArr.count > 0 {
                let object = jsonArr[0] as! Dictionary<String, Any>
                let rootDic = object["rootTopic"] as? Dictionary<String, Any>
                return rootDic
            }
        } catch let error as Error? {
            print("读取本地数据出现错误!",error as Any)
        }
        
        return nil
    }
}
