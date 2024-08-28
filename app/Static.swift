//
//  StaticVariable.swift
//  app
//
//  Created by 조민기 on 6/5/24.
//

import Foundation

class Static {
    static let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    static var viewUrl = ""
    static var action = ""
}
