//
//  YCILog.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/5.
//

import Foundation

/* TODO:
 type(of:) 获取类名，不带模块名，需要确定下 集成pod方式是否需要带
 *.增加 filter,日志过滤器
 YCILogable, 模块中 log? 使用，通过模块外赋值，确定是否有NSLog类对象，以此开启关闭模块日志
 Obj-C 中使用时，与宏配合？并在工程中单独创建一个swift类，方便配置调用
 
 */

/*
 使用说明：
 
 控制台级：  YCILog.console()
    无论版本配置 Debug, QA, Release 都需要输出的日志。
    通常是 组件 start，end 信息
 
 追踪级：    YCILog.track()
    需要追踪的用户使用信息，并必需要上传
 
 调试级：    logger.debug(), verbose, ...
    使用 logger 的方式实现 开关功能，在各模块需要调试时，按需开启详细日志信息。
 
    swift：
        组件接口类声明该变量：
        public var logger: YCILog.Type?
 
 */

public var YCILogKitLogger: YCILog.Type?

public class YCILog: NSObject {
    
    public enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
        
        case track = 5  // 用户信息追踪
    }
    
    // 目标集
    public private(set) static var destinations = Set<BaseDestination>()
    
    // MARK: 目标处理
    
    
    @discardableResult
    public class func addDestination(_ destination: BaseDestination) -> Bool {
        if destinations.contains(destination) {
            return false
        }
        destinations.insert(destination)
        return true
    }
    
    
    @discardableResult
    public class func removeDestination(_ destination: BaseDestination) -> Bool {
        if destinations.contains(destination) == false {
            return false
        }
        destinations.remove(destination)
        return true
    }
    
    
    public class func removeAllDestinations() {
        destinations.removeAll()
    }
    
    
    public class func countDestinations() -> Int {
        return destinations.count
    }
    
    /// 当前线程名
    class func threadName() -> String {
        
        if Thread.isMainThread {
            return ""
        } else {
            let threadName = Thread.current.name
            if let threadName = threadName, !threadName.isEmpty {
                return threadName
            } else {
                return String(format: "%p", Thread.current)
            }
        }
    }
    
    
    
}


extension YCILog {
    // MARK: 各级日志
    
    /// 最低级 - 不重要的
    public class func verbose(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        custom(level: .verbose, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 低级 - 调试时的帮助信息
    public class func debug(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        custom(level: .debug, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 普通级 - 有帮助，但还不是问题或错误
    public class func info(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        custom(level: .info, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 高级 - 可能会引起大麻烦
    public class func warning(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        custom(level: .warning, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 最高级 - 午夜惊魂
    public class func error(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        custom(level: .error, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 用户级 - 追踪用户信息
    public class func track(_ message: @autoclosure () -> Any, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
        custom(level: .track, message: message, file: file, function: function, line: line, context: context)
    }
    
    /// 控制台级 - 必定会打印到控制台
    public class func console(_ message: @autoclosure () -> Any) {
        
        NSLog("\n 👉  CONSOLE  - \(message())")
        
    }
    
    /// 自定义日志信息
    public class func custom(level: YCILog.Level, message: @autoclosure () -> Any,
                             file: String = #file, function: String = #function, line: Int = #line, context: Any? = nil) {
        // message json 化
        var msg = message()
        
        if JSONSerialization.isValidJSONObject(msg) {
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: msg, options: [])
                
                if let jsonStr = String.init(data: jsonData, encoding: .utf8) {
                    msg = jsonStr
                }
                
            } catch  {

            }
            
        }
        
        dispatch_send(level: level, message: msg, thread: threadName(),
                      file: file, function: function, line: line, context: context)
    }
    
    
    class func dispatch_send(level: YCILog.Level, message: @autoclosure () -> Any,
                             thread: String, file: String, function: String, line: Int, context: Any?) {
        
        var resolvedMessage: String?
        for dest in destinations {
            
            guard let queue = dest.queue else {
                continue
            }
            
            resolvedMessage = resolvedMessage ?? "\(message())"
            
            if dest.shouldLevelBeLogged(level, path: file, function: function, message: resolvedMessage) {
                // try to convert msg object to String and put it on queue
                let msgStr = resolvedMessage == nil ? "\(message())" : resolvedMessage!
                let f = stripParams(function: function)
                
                if dest.asynchronously {
                    queue.async {
                        _ = dest.send(level, msg: msgStr, thread: thread, file: file, function: f, line: line, context: context)
                    }
                } else {
                    queue.sync {
                        _ = dest.send(level, msg: msgStr, thread: thread, file: file, function: f, line: line, context: context)
                    }
                }
            }
        }
        
    }
    /*
     /// internal helper which dispatches send to dedicated queue if minLevel is ok
     class func dispatch_send(level: YCILog.Level, message: @autoclosure () -> Any,
     thread: String, file: String, function: String, line: Int, context: Any?) {
     var resolvedMessage: String?
     for dest in destinations {
     
     guard let queue = dest.queue else {
     continue
     }
     
     resolvedMessage = resolvedMessage == nil && dest.hasMessageFilters() ? "\(message())" : resolvedMessage
     if dest.shouldLevelBeLogged(level, path: file, function: function, message: resolvedMessage) {
     // try to convert msg object to String and put it on queue
     let msgStr = resolvedMessage == nil ? "\(message())" : resolvedMessage!
     let f = stripParams(function: function)
     
     if dest.asynchronously {
     queue.async {
     _ = dest.send(level, msg: msgStr, thread: thread, file: file, function: f, line: line, context: context)
     }
     } else {
     queue.sync {
     _ = dest.send(level, msg: msgStr, thread: thread, file: file, function: f, line: line, context: context)
     }
     }
     }
     }
     }
     
     */
    
    /**
     DEPRECATED & NEEDS COMPLETE REWRITE DUE TO SWIFT 3 AND GENERAL INCORRECT LOGIC
     Flush all destinations to make sure all logging messages have been written out
     Returns after all messages flushed or timeout seconds
     
     - returns: true if all messages flushed, false if timeout or error occurred
     */
    public class func flush(secondTimeout: Int64) -> Bool {
        
        /*
         guard let grp = dispatch_group_create() else { return false }
         for dest in destinations {
         if let queue = dest.queue {
         dispatch_group_enter(grp)
         queue.asynchronously(execute: {
         dest.flush()
         grp.leave()
         })
         }
         }
         let waitUntil = DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), secondTimeout * 1000000000)
         return dispatch_group_wait(grp, waitUntil) == 0
         */
        return true
    }
    
    /// 删除方法参数
    class func stripParams(function: String) -> String {
        var f = function
        if let indexOfBrace = f.index(of:"(") {
            f = String(f[..<indexOfBrace])
        }
        f += "()"
        return f
    }
}

extension YCILog { // 方便调用
    
    /// 追踪用户信息 - 便捷调用
    public class func trackEvent(event: String, page: String? = nil, content: Dictionary<String, Any>, _
        file: String = #file, _ function: String = #function, line: Int = #line, context: Any? = nil) {
    
        var allContent : [String : Any] = ["event" : event]
        
        if let p = page {
            allContent["page"] = p;
        }
        
        allContent.merge(content, uniquingKeysWith: { (current, _) in current })
        
        custom(level: .track, message: allContent, file: file, function: function, line: line, context: context)
    }
    
}



