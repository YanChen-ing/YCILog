//
//  BaseDestination.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/14.
//

import Foundation
import Dispatch

let OS = "iOS"

/// 目标基类，不能直接使用
open class BaseDestination: Hashable, Equatable {
    
    /// 在自己串行队列中执行
    open var asynchronously = true
    
    /// 最低日志处理级别
    open var minLevel = YCILog.Level.verbose
    
    /// 级别名称集
    open var levelString = LevelString()
    
    /// 级别颜色集
    open var levelColor = LevelColor()
    
    public struct LevelString {
        public var verbose = "VERBOSE"
        public var debug = "DEBUG"
        public var info = "INFO"
        public var warning = "WARNING"
        public var error = "ERROR"
        public var track = "TRACK"
    }
    
    // 级别名称显示时的颜色。默认无
    public struct LevelColor {
        public var verbose = ""     // silver
        public var debug = ""       // green
        public var info = ""        // blue
        public var warning = ""     // yellow
        public var error = ""       // red
        public var track = ""       //
    }
    
    var reset = ""
    var escape = ""
    
//    var filters = [FilterType]()
    let formatter = DateFormatter()
    let startDate = Date()
    
    // 每个目标必须有其哈希值
    lazy public var hashValue: Int = self.defaultHashValue
    open var defaultHashValue: Int {return 0}
    
    
    // 每个目标实例，须有一个串行队列，保证串行输出。
    // 优先级在 用户操作 ，工具 之间
    var queue: DispatchQueue? //dispatch_queue_t?
    var debugPrint = false // set to true to debug the internal filter logic of the class
    
    public init() {
        let uuid = NSUUID().uuidString
        let queueLabel = "YCILog-queue-" + uuid
        queue = DispatchQueue(label: queueLabel, target: queue)
    }
    
    /// 整理日志格式。 向子类提供格式化后的日志
    open func send(_ level: YCILog.Level, msg: String, thread: String, file: String,
                   function: String, line: Int, context: Any? = nil) -> String? {
        
        let date = formatDate("HH:mm:ss.SSS")
        let color = escape + colorForLevel(level)
        let levelword = levelWord(level)
        let fileName = fileNameWithoutSuffix(file)
        
        let text = "\(date)\n \(color) \(levelword) \(reset) \(fileName).\(function):\(line) - \(msg)"
        
        return text
    }
    
    /// 返回各级名
    func levelWord(_ level: YCILog.Level) -> String {
        
        var str = ""
        
        switch level {
        case YCILog.Level.debug:
            str = levelString.debug
            
        case YCILog.Level.info:
            str = levelString.info
            
        case YCILog.Level.warning:
            str = levelString.warning
            
        case YCILog.Level.error:
            str = levelString.error
            
        case YCILog.Level.track:
            str = levelString.track
            
        default:
            // Verbose is default
            str = levelString.verbose
        }
        return str
    }
    
    /// 返回各级颜色
    func colorForLevel(_ level: YCILog.Level) -> String {
        var color = ""
        
        switch level {
        case YCILog.Level.debug:
            color = levelColor.debug
            
        case YCILog.Level.info:
            color = levelColor.info
            
        case YCILog.Level.warning:
            color = levelColor.warning
            
        case YCILog.Level.error:
            color = levelColor.error
            
        case YCILog.Level.track:
            color = levelColor.track
            
        default:
            color = levelColor.verbose
        }
        return color
    }
    
    /// 从路径中获取文件名
    func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }
    
    /// 文件名，无后缀
    func fileNameWithoutSuffix(_ file: String) -> String {
        let fileName = fileNameOfFile(file)
        
        if !fileName.isEmpty {
            let fileNameParts = fileName.components(separatedBy: ".")
            if let firstPart = fileNameParts.first {
                return firstPart
            }
        }
        return ""
    }
    
    /// 当前格式化日期
    /// 时区可选，例：timeZone = "UTC"
    func formatDate(_ dateFormat: String, timeZone: String = "") -> String {
        if !timeZone.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        formatter.dateFormat = dateFormat
        //let dateStr = formatter.string(from: NSDate() as Date)
        let dateStr = formatter.string(from: Date())
        return dateStr
    }
    
    /// 正常运行时间
    func uptime() -> String {
        let interval = Date().timeIntervalSince(startDate)
        
        let hours = Int(interval) / 3600
        let minutes = Int(interval / 60) - Int(hours * 60)
        let seconds = Int(interval) - (Int(interval / 60) * 60)
        let milliseconds = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%03d", arguments: [hours, minutes, seconds, milliseconds])
    }
    
    /// returns the json-encoded string value
    /// after it was encoded by jsonStringFromDict
    func jsonStringValue(_ jsonString: String?, key: String) -> String {
        guard let str = jsonString else {
            return ""
        }
        
        // remove the leading {"key":" from the json string and the final }
        let offset = key.count + 5
        let endIndex = str.index(str.startIndex,
                                 offsetBy: str.count - 2)
        let range = str.index(str.startIndex, offsetBy: offset)..<endIndex
        
        return String(str[range])
    }
    
    /// dict -> jsonString
    func jsonStringFromDict(_ dict: [String: Any]) -> String? {
        var jsonString: String?
        
        // try to create JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)
        } catch {
            print("YCILog could not create JSON from dict.")
        }
        return jsonString
    }

    // MARK:- 过滤
    func shouldLevelBeLogged(_ level: YCILog.Level, path: String,
                             function: String, message: String? = nil) -> Bool {
        
        if level.rawValue >= minLevel.rawValue {
            return true
        } else {
            return false
        }
    }
        
    
    /**
     用于触发子类缓冲，后台运行。
     用于目标将缓冲的日志，发送到最终目的地（如：服务器端）
     */
    func flush() {
        
    }
}

public func == (lhs: BaseDestination, rhs: BaseDestination) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
