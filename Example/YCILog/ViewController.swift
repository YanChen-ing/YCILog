//
//  ViewController.swift
//  YCILog
//
//  Created by YanChen-ing on 04/11/2019.
//  Copyright (c) 2019 YanChen-ing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        
        //        print("btn1Clicked")
        
        //        let info = ["method":"btn1Clicked",
        //                    "page":"abc"]
        //        log.track(info)
        
        //        log.track("btn1Clicked")
        //
        //        log.debug("abc.....")
        //
        //        log.error("test...")
        
        //        log.trackEvent(event: "share", content: ["abc":""])
        
        log.trackEvent(event: "share", content: ["abc":""])
        
//        log.console("test for console Start/End")
        
    }

}

