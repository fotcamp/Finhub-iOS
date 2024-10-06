//
//  LoginProtocol.swift
//  app
//
//  Created by 조민기 on 10/6/24.
//

import Foundation

typealias LoginResult = (_ token: String?, _ error: Error?) -> Void

protocol LoginDelegate {
    func login(complete result: LoginResult?)
}

