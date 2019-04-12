//
//  YCILogConfig.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/5.
//

import Foundation

public class YCILogConfig: NSObject {
    
    static var shared = YCILogConfig()
    
    /// 必要信息, 每条日志必有的信息. 用于设置设备信息, 用户信息等
    public var requiredInfos: [String: Any]?
    
    public var consoleLog: Bool = false
    
    public var uploadClosure: (_ filePath: String) -> Void
    
    public var uploadCrashClosure: (_ content: String) -> Void
    
    
//    /// 默认：每30条信息，存储本地一次
//    public var countToSave: Int = 30
    
    init(uploadClosure:  @escaping (_ filePath: String) -> Void = {_ in }, uploadCrashClosure: @escaping (_ content: String) -> Void = {_ in } ) {
        
        self.uploadClosure = uploadClosure
        self.uploadCrashClosure = uploadCrashClosure
    }
    
    
//    enum UploadStrategy {
//        case appLaunch
//        case timeInterval
//        case batch
//        case each
//    }
//
//    var uploadStrategy: UploadStrategy = .appLaunch
    
    // MARK:- Keys
    
    public struct LogKey {
        
        public var logId = "logId"
        public var time  = "time"
        public var page  = "page"
        public var event = "event"
        public var attributes = "attributes"
        public var extend = "extend"
        
    }

    public var logKey = LogKey()
    
    
    // MARK:- Events
    public struct LogEvent {
        
        public var pageBegin = "page_begin"
        public var pageEnd   = "page_end"
        
    }
    
}

