//
//  String+Extension.swift
//  app
//
//  Created by 조민기 on 4/30/24.
//

import Foundation

extension String {
    public func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
}

