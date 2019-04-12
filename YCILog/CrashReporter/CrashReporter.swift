//
//  AutoTracker.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/19.
//

import Foundation

public class CrashReporter: NSObject {
    
    public static let shared = CrashReporter()
    
    public func start() {
        
        YCILogKitLogger?.info("start")
        
        if let crashReport = YCILogCrashManager.sharedInstance().startPLCrashReporter() {
            
            let dic = ["event":"yci_crash",
                       "crashReport":crashReport]
            
            YCILog.error(dic)
            
            YCILogCrashManager.sharedInstance().uploadCrashReportSuccess()
            
        }
        
//        // 制造崩溃
//        let a = [1,2]
//        a[3]
        
    }
    
    
}


