//
//  AutoTracker.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/19.
//

import Foundation

public class AutoTracker {
    
    public struct Options : OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let PV           = Options(rawValue: 1 << 0)
        public static let UIControl    = Options(rawValue: 1 << 1)
        
        public static let All: Options = [.PV, .UIControl]
    }
    
    
    public static func start(options: Options = .All) {
        
        YCILogKitLogger?.info("start")
        
        TrackNeeds.shared.update()
        
        // TODO: 异常处理
    
        AppDelegateTracker.shared.startTracker() // 监听应用启动，终止
        
        if options.contains(.PV) {
            UIViewController.startAutoPV(options: [.pageBegin])
        }
        
        if options.contains(.UIControl) {
            UIControl.startTracker()
        }
        
    }
    
    
}
