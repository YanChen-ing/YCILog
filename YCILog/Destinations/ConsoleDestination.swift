//
//  ConsoleDestination.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/14.
//

import Foundation

public class ConsoleDestination: BaseDestination {
    
    /// 使用NSLog 代替打印，默认否
    public var useNSLog = false
    /// 使用终端中颜色 替代 Xcode 控制台颜色，默认否
    public var useTerminalColors: Bool = false {
        didSet {
            if useTerminalColors {
                // 使用终端中颜色
                reset = "\u{001b}[0m"
                escape = "\u{001b}[38;5;"
                levelColor.verbose = "251m"     // silver
                levelColor.debug = "35m"        // green
                levelColor.info = "38m"         // blue
                levelColor.warning = "178m"     // yellow
                levelColor.error = "197m"       // red
                levelColor.track = "38m"        // blue  = .info
                
            } else {
                // Xcode中， 使用 Emojis 更易区分日志级别
                levelColor.verbose = "💜 "     // silver
                levelColor.debug = "💚 "        // green
                levelColor.info = "💙 "         // blue
                levelColor.warning = "💛 "     // yellow
                levelColor.error = "❤️ "       // red
                levelString.track = "✅ "      // green
                
            }
        }
    }
    
    override public var defaultHashValue: Int { return 1 }
    
    public override init() {
        super.init()
        levelColor.verbose = "💜 "     // silver
        levelColor.debug = "💚 "        // green
        levelColor.info = "💙 "         // blue
        levelColor.warning = "💛 "     // yellow
        levelColor.error = "❤️ "       // red
        levelColor.track = "✅ "      // green 
    }
    
    // Xcode 控制台打印
    override public func send(_ level: YCILog.Level, msg: String, thread: String,
                              file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
        
        if let str = formattedString {
            if useNSLog {
                NSLog("%@", str)
            } else {
                print(str)
            }
        }
        return formattedString
    }
    
}
