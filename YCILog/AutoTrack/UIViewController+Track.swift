//
//  UIViewController+Ext.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/8.
//

import Foundation

// MARK: - AutoPV 自动页面浏览统计

extension UIViewController {

    struct AutoOptions : OptionSet {
        let rawValue: Int
        
        static let pageBegin  = AutoOptions(rawValue: 1 << 0)
        static let pageEnd    = AutoOptions(rawValue: 1 << 1)
    }
    
    static func startAutoPV(options: AutoOptions) {
        
        if options.contains(.pageBegin) {
            _ = swizzleOnce_begin
        }
        
        if options.contains(.pageEnd) {
            _ = swizzleOnce_end
        }
        
    }
    
    static var swizzleOnce_begin: Void = {
        
        YCILg_swizzleInstanceMethod(originalSel: #selector(viewDidAppear(_:)), newSel: #selector(yciLg_viewDidAppear(animated:)))
    }()
    
    static var swizzleOnce_end: Void = {
        
        YCILg_swizzleInstanceMethod(originalSel: #selector(viewDidDisappear(_:)), newSel: #selector(yciLg_viewDidDisappear(animated:)))
    }()
    
    static let eventPageBegin = "yci_page_begin"
    static let eventPageEnd   = "yci_page_end"
   
    
    @objc func yciLg_viewDidAppear(animated: Bool) {
        
        logPageInfo(event: UIViewController.eventPageBegin)
        
        yciLg_viewDidAppear(animated: animated)
        
    }
    
    @objc func yciLg_viewDidDisappear(animated: Bool) {
        
        logPageInfo(event: UIViewController.eventPageEnd)
        
        yciLg_viewDidDisappear(animated: animated)
        
    }
    
    private func logPageInfo(event: String) {
        
        // 只统计自定义页面
        
//        let className = Tools.className(withoutMainBundleNameSpace: NSStringFromClass(self.classForCoder)) // 过滤主模块名
        
        let className = String(describing: type(of: self)) // 不带 模块名
        
        if !className.hasPrefix("UI") {
            
            var dic: [String : String] = [:]
            
            if let title = self.title {
                dic["title"] = title
            }
            
            // 记录
            let config = YCILogConfig.shared
            
            dic[config.logKey.event] = event
            dic[config.logKey.page]  = className
            
            YCILog.track(dic)
        }
        
        
    }
    
}
