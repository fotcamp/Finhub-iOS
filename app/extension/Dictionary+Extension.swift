//
//  Dictionary+Extension.swift
//  app
//
//  Created by 조민기 on 4/6/24.
//

import Foundation

extension Dictionary {
    var toJsonString: String {
        get {
            guard 
                let jsonData = try? JSONSerialization.data(withJSONObject: self)
            else { return "" }
            
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
    }
}
