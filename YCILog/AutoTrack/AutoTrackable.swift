//
//  AutoTrackable.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/8.
//

import Foundation

protocol AutoTrackable where Self: NSObject {
    
    static func startTracker()
    
    
}


extension UIView {
    
    /// md5 viewPath
    func eventId(action:String?) -> String {
        
        // UIViewController/UIView[0]/UIButton[1]&touch
        let eventPath = viewPath() + "&" + (action ?? "")
        
//        print("eventPath: " + eventPath)
        YCILogKitLogger?.debug("eventPath: " + eventPath)
        
        // eventPath -> MD5 -> 缩减
        let eventId = shortString(str: MD5(eventPath))
        
        YCILogKitLogger?.info("eventId: " + eventId)
        
        return eventId
    }
    
    
}


/// 缩短字符串
/// 每 n 位一组，合并成一个字符串，从而缩短字符串
///
/// - Parameters:
///   - str: 原字符串
///   - length: 缩减到长度
/// - Returns: 缩减后的字符串
fileprivate func shortString(str:String, length:Int = 8) -> String {
    
    let chars = ["a" , "b" , "c" , "d" , "e" , "f" , "g" , "h" ,
                 "i" , "j" , "k" , "l" , "m" , "n" , "o" , "p" , "q" , "r" , "s" , "t" ,
                 "u" , "v" , "w" , "x" , "y" , "z" , "0" , "1" , "2" , "3" , "4" , "5" ,
                 "6" , "7" , "8" , "9" , "A" , "B" , "C" , "D" , "E" , "F" , "G" , "H" ,
                 "I" , "J" , "K" , "L" , "M" , "N" , "O" , "P" , "Q" , "R" , "S" , "T" ,
                 "U" , "V" , "W" , "X" , "Y" , "Z"]
    
    // 每 n 位一组，合并成一个字符
    let n = Int(ceilf(Float(str.count)/Float(length))), charsCount = chars.count
    
    var res = "", sum = 0, count = n
    
    for scalar in str.unicodeScalars {
        
        if count == 0 {
            // 取字符
            res.append(chars[sum % charsCount])
            
            sum = 0
            count = n
        }
    
        // ASCII 累加
        sum += Int(scalar.value)

        count -= 1
    }
    
    // 取最后一位
    if sum != 0 {
        res.append(chars[sum % charsCount])
    }
    
    return res
}

extension UIResponder {
    
    /// 视图树，递归获取视图树结构。根节点到 UIViewController 子类。 尾递归
    /// UIViewController/UIView[0]/UIButton[1]
    ///
    /// - Returns: 视图树字符串
    func viewPath(_ subPath: String = "") -> String{
        
        
        //        let className = NSStringFromClass(self.classForCoder) //带 模块名
        
        let className = String(describing: type(of: self)) // 不带 模块名
        
        // 过滤 内部视图页
        if className.hasPrefix("_") {
            if let next = self.next {
                return next.viewPath(subPath)
            } else {
                return subPath
            }
        }
        
        var currentPath = ""  // 3. 默认 其他响应类，忽略本类信息
        
        if self.isKind(of: UIViewController.classForCoder()) || self.isKind(of: UIWindow.classForCoder()) {
            // 1. 控制器类 或 窗口类，返回本类名
            
            let currentFullPath = className + subPath
            
            return currentFullPath
            
            
        } else if self.isKind(of: UIView.classForCoder()) {
            // 2. 视图类，在上层 viewPath 后拼接本类信息
            
            var path = "/\(className)"
            
            // 注：在父视图序号，可重用的排除。例：UITableViewCell，UICollectionViewCell
            if let next = self.next, next.isKind(of: UIView.classForCoder()), !self.isKind(of: UITableViewCell.classForCoder()), !self.isKind(of: UICollectionViewCell.classForCoder()) {
                
                let idx = (next as! UIView).subviews.index(of: self as! UIView) ?? 0
                
                path.append("[\(idx)]")
            }
            
            currentPath = path
        }
        
        // 生成当前全路径
        let currentFullPath = currentPath + subPath
        
        if let next = self.next{
            return next.viewPath(currentFullPath)
        } else {
            return currentFullPath
        }
        
    }
    
    /*
    
    /// 视图树，递归获取视图树结构。根节点到 UIViewController 子类。
    /// UIViewController/UIView[0]/UIButton[1]
    ///
    /// - Returns: 视图树字符串
    func viewPath() -> String {
        
        
//        let className = NSStringFromClass(self.classForCoder) //带 模块名

        let className = String(describing: type(of: self)) // 不带 模块名
        
        // 过滤 内部视图页
        if className.hasPrefix("_") {
            if let next = self.next {
                return next.viewPath() 
            } else {
                return ""
            }
        }
        
        if self.isKind(of: UIViewController.classForCoder()) || self.isKind(of: UIWindow.classForCoder()) {
            // 1. 控制器类 或 窗口类，返回本类名
 
            
            return className
            
        } else if self.isKind(of: UIView.classForCoder()) {
            // 2. 视图类，在上层 viewPath 后拼接本类信息
            
            var path = self.next?.viewPath() ?? ""
            
            path.append("/\(className)")
            
            if let next = self.next, next.isKind(of: UIView.classForCoder()) {
                
                let idx = (next as! UIView).subviews.index(of: self as! UIView) ?? 0
                
                path.append("[\(idx)]")
            }
            
            return path
        }
        
        // 3. 其他响应类，忽略本类信息
        return self.next?.viewPath() ?? ""
        
    }
    
    */
}
