//
//  SGBLog.swift
//  kacrm
//
//  Created by yanchen on 2018/6/19.
//  Copyright © 2018年 yanchen. All rights reserved.
//

import YCILog

import BIZMobileSDK


class SGBLog: NSObject {
    
    @objc public class func start() {
        
        assert(!BIZMobile.config.appKey.isEmpty, "请先启动 BIZMobileSDK")
    
        
        if SGB_DEBUG == 1 {
        
            startDebugVersion()    // 调试版本
            
        } else {
            
            startReleaseVersion()  // 发布版本
        }
        
    }
    
    /// 启动 Debug 版本 日志收集
    class func startDebugVersion() {
        
        let c = BIZMobile.config
        
        //========= 设置 日志流 目的地 =========
        
        // 1. 控制台
        
        let console = ConsoleDestination()
        BIZLog.addDestination(console)
        
        
        // 显示 BIZLog.swift 组件内信息
            BIZLog_swift.logger = BIZLog.self
    
        // 2. 移动平台
        let bizMobile = BIZMobileDestination(appID:c.appKey, appSecret: c.appSecret, encryptionKey: "")
        
        bizMobile.sendingPoints.track = 500
        
        let baseServer = URL(string: c.server)
        
        bizMobile.serverURL = URL(string: "/sdk/analysis/log.do", relativeTo: baseServer)
        
        bizMobile.getUserInfoClosure = {
            return ["userName":SGBUserInfoPersister.userInfo()?.username ?? ""]
        }
        
        // 显示 对象运行日志
                bizMobile.showNSLog = true
        
        BIZLog.addDestination(bizMobile)
        
        //========= 启动 更多功能 =========
        
        if SGB_ON_LOOG_TRACK == 1 {
            
            // 启动 自动追踪
            AutoTracker.start(options: [.PV])
        }
        
        // 启动 崩溃日志收集
        CrashReporter.shared.start()
        
    }
    
    
    /// 启动 Release 版本 日志收集
    class func startReleaseVersion() {
        
        let c = BIZMobile.config
        
        //========= 设置 日志流 目的地 =========
        
        // 1. 移动平台
        let bizMobile = BIZMobileDestination(appID:c.appKey, appSecret: c.appSecret, encryptionKey: "")
        
        bizMobile.sendingPoints.track = 50
        
        let baseServer = URL(string: c.httpsServer)
        
        bizMobile.serverURL = URL(string: "/sdk/analysis/log.do", relativeTo: baseServer)
        
        bizMobile.getUserInfoClosure = {
            return ["userName":SGBUserInfoPersister.userInfo()?.username ?? ""]
        }
        
        BIZLog.addDestination(bizMobile)
        
        //========= 启动 更多功能 =========
        
        
        if SGB_ON_LOOG_TRACK == 1 {
            
            // 启动 自动追踪
            AutoTracker.start(options: [.PV])
        }
        
        // 启动 崩溃日志收集
        CrashReporter.shared.start()
        
    }
    
    /*
    /// 最低级 - 不重要的
    @objc public class func verbose(_ message: String = "",
        file: String ,  function: String ,line: Int) {
        
        BIZLog.custom(level: .verbose, message: message, file: file, function: function, line: line, context: nil)
    }
    
    /// 低级 - 调试时的帮助信息
    @objc public class func debug(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        BIZLog.custom(level: .debug, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 普通级 - 有帮助，但还不是问题或错误
    @objc public class func info(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        BIZLog.custom(level: .info, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 高级 - 可能会引起大麻烦
    @objc public class func warning(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        BIZLog.custom(level: .warning, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 最高级 - 午夜惊魂
    @objc public class func error(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        BIZLog.custom(level: .error, message: message, file: file, function: function, line: line, context: context)
    }
 */
    
    /// 控制台级 - 打印到控制台的信息
    @objc public class func console(_ message: Any) {
        
//        NSLog("\n 👉  CONSOLE  - \(message())")
        BIZLog.console(message)
        
    }
    
    /// 用户级 - 记录用户信息
    @objc public class func track(_ message: Dictionary<String, Any>, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        BIZLog.custom(level: .track, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 用户日志 手动埋点 - 便捷方法
    @objc public class func trackEvent(event: String, page: String? = nil, content: Dictionary<String, Any>) {
        
        var allContent : [String : Any] = ["event" : event]
        
        if let p = page {
            allContent["page"] = p;
        }
        
        allContent.merge(content, uniquingKeysWith: { (current, _) in current })
        
        BIZLog.custom(level: .track, message: allContent, file: "", function: "", line: 0, context: nil)
    }
    
    
    
}
