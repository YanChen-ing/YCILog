//
//  UIControl+Ext.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/11.
//

import Foundation

extension UIControl: AutoTrackable {
    
    static func startTracker() {
        _ = swizzleOnce
    }
    
    static var swizzleOnce: Void = {
        
        YCILg_swizzleInstanceMethod(originalSel: #selector(UIControl.endTracking(_:with:)), newSel: #selector(yci_endTracking(_:with:)))
        
    }()
    
    @objc func yci_endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        // 监听 UIButton
        if self.isMember(of: UIButton.classForCoder()) {
            
            let targets = Array(self.allTargets)
            
            if targets.count > 0 {
                
                let actions = self.actions(forTarget: targets.first, forControlEvent: .touchUpInside)
                
                
                if  (actions?.count ?? 0) > 0, (actions?.first?.count ?? 0) > 0 {
                    
                    // id
                    let eventId = self.eventId(action: actions?.first)
                    
                    // 需求信息
                    guard let oneNeed = TrackNeeds.shared.oneNeed(for: eventId) else {
                        return
                    }
                    
                    // 收集需求
                    let info = self.infos(for: oneNeed)
                    
                    YCILog.track(info)
                    
                }
                
            }
            
        }
        
        // 回调原本处理方法
        self.yci_endTracking(touch, with: event)
        
    }
    
    
    open override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
}
