//
//  Dictionary+Extension.swift
//  app
//
//  Created by 조민기 on 4/6/24.
//

import Foundation

typealias JSON = Dictionary<String, Any>

extension JSON {
    var toJsonString: String {
        get {
            guard 
                let jsonData = try? JSONSerialization.data(withJSONObject: self)
            else { return "" }
            
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
    }
    
    mutating func put(key: String, value: Any) -> Void {
        self[key] = value
    }
    
    func getString(_ key: String) -> String? {
        return self[key] as? String
    }
    
    func getJsonObject(_ key: String) -> JSON? {
        return self[key] as? JSON
    }
    
    func getJsonArray(_ key: String) -> [JSON]? {
        return self[key] as? [JSON]
    }
}
