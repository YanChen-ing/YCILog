//
//  AppDelegate.swift
//  YCILog
//
//  Created by YanChen-ing on 04/11/2019.
//  Copyright (c) 2019 YanChen-ing. All rights reserved.
//

import UIKit

import YCILog

let log: YCILog.Type = YCILog.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let console = ConsoleDestination()
        
        // TODO: 可以启动自定义 Destination
        
        log.addDestination(console)
        
        YCILogKitLogger = YCILog.self
        
        AutoTracker.start(options: [.PV, .UIControl])
        
        CrashReporter.shared.start()
        
        //        let a = [1,2]
        //
        //        a[3]
        
        //        let a = NSArray.init(object: 1)
        //
        //        a[3]
        
        
        return true
    }


}

