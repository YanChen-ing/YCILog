//
//  AppDelegate+Track.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/8/2.
//

import Foundation

public class AppDelegateTracker {
    
    static let shared = AppDelegateTracker()
    
    var appActiveCount: UInt = 0
    
    var appStartTime: TimeInterval = Date().timeIntervalSince1970
    
    public func startTracker() {
        
        // 这里尽早记录，若首次通过监听记录，则会出现先记录PV事件，再记录启动的情况
        recordAppStart()
        
        // 注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(recordAppStart), name: .UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recordAppEnd), name: .UIApplicationWillResignActive, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func recordAppStart() {
        
        appActiveCount += 1
        
        if appActiveCount == 2 { // 首次启动时，DidBecomeActive 略过
            return;
        }
        
        let uploadActiveCount = appActiveCount > 1 ? appActiveCount-1 : 1 // 激活次数
        
        appStartTime = Date().timeIntervalSince1970
        
        let info = [YCILogConfig.shared.logKey.event: "app_start",
                    "activeCount": uploadActiveCount] as [String : Any]
        
        YCILog.track(info)
        
    }
    
    @objc func recordAppEnd() {
        
        let runtime = round((Date().timeIntervalSince1970 - appStartTime)*1000)/1000.0
    
        let info = [YCILogConfig.shared.logKey.event: "app_end",
                    "runtime":runtime] as [String : Any]
        
        YCILog.track(info)
    }
    
    
}

//extension Double {
//
//    /// Rounds the double to decimal places value
//
//    func roundTo(places:Int) -> Double {
//
//        let divisor = pow(10.0, Double(places))
//
//        return (self * divisor).rounded() / divisor
//
//    }
//
//}
