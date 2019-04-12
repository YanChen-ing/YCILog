//
//  Tools.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/12.
//

import Foundation

class Tools {
    
    static var mainBundleModuleName = (Bundle.main.infoDictionary!["CFBundleExecutable"] as! String).replacingOccurrences(of: ".", with: "_")
    
    final class func className(withoutMainBundleNameSpace className:String) -> String {
        
        var className = className
        
        if className.hasPrefix(mainBundleModuleName) {
            let range = className.startIndex..<className.index(className.startIndex, offsetBy: mainBundleModuleName.count+1)
            className.removeSubrange(range)
        }
        
        return className
    }
}
