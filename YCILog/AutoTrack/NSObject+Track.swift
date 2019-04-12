//
//  NSObject+Ext.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/8.
//

import Foundation

extension NSObject {
    
    /// 交换方法实现。实现运行时方法顺序调换
    ///
    /// - Parameters:
    ///   - originalSel: 原方法
    ///   - newSel: 新方法
    final class func YCILg_swizzleInstanceMethod(originalSel: Selector, newSel: Selector) {
        
        let orignalMethod = class_getInstanceMethod(self, originalSel)
        
        let newMethod = class_getInstanceMethod(self, newSel)
        
        guard orignalMethod != nil, newMethod != nil else {
            
//            throw Error.init(code: .swizzleFailed, reason: "class: \(NSStringFromClass(self))")
            
            return
            
        }
        
        method_exchangeImplementations(orignalMethod!, newMethod!);
        
    }
    
}

