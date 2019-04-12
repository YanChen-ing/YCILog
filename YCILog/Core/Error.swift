//
//  Error.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/12.
//

import Foundation

final class Error: Swift.Error {
    
    let code: Error.Code
    
    let reasonDescription: String
    
    var localizedDescription: String {
        return "YCIError: \(code.message).\n    - reason: \(reasonDescription)"
    }
    
    init(code:Error.Code, reason: String = "") {
        self.code = code
        self.reasonDescription = reason
    }
    
    enum Code: Int {
        case swizzleFailed
        
        var message:String {
            
            switch self {
            case .swizzleFailed:
                return "swizzleFailed"
                //            default:
                //                return "unKnowed Error"
            }
            
        }
    }
    
    
    
}


