//
//  GoogleLogin.swift
//  app
//
//  Created by 조민기 on 10/6/24.
//

import Foundation
import GoogleSignIn

class GoogleLogin: LoginDelegate {
    func login(complete result: LoginResult?) {
        guard let viewController = SwiftSupport.topViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { auth, error in
            result?(auth?.serverAuthCode, error)
        }
    }
}
