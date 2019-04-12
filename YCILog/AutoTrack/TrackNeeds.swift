//
//  Needs.swift
//  YCILog.swift
//
//  Created by yanchen on 2018/6/11.
//

import Foundation

/// 需求类
///
/// 管理日志需求更新，id比对
class TrackNeeds {
    
    static let shared = TrackNeeds()
    
    var needsFilePath: String? = Bundle.main.path(forResource: "YCITrackNeeds", ofType: "json")
    
    private var needs: [String : OneNeed]?
    
    /// 需求，定义
    struct OneNeed: Codable {
        
        var const: [String : String]?
        var kvc:   [String : String]?
    }
}

extension TrackNeeds {
    
    func update() {
        
        guard let path = needsFilePath else {
            print("没有日志需求文件，请检查 YCITrackNeeds.json 文件")
            return
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            return
        }
        
        needs = try? JSONDecoder().decode([String : OneNeed].self, from: data)
        
    }
    
    func oneNeed(for eventId: String) -> OneNeed? {
        
        guard let needsDic = needs, let need = needsDic[eventId]  else {
            return nil
        }
        
        return need
    }
    
}

extension AutoTrackable where Self : NSObject {
    
    func infos(for oneNeed: TrackNeeds.OneNeed) -> [String : Any] {
        
        var dic: [String : Any] = [:]
        
        // const
        if let constDic = oneNeed.const {
           dic = dic.merging(constDic) { (_, new) in new }
        }
        
        // kvc
        if let kvcDic = oneNeed.kvc {
            for (key,keyPath) in kvcDic {
                
                if let value = self.value(forKeyPath: keyPath) {
                    dic[key] = value as? String
                }
                
            }
        }
        
        return dic
        
        
    }
    
}


