//
//  KakaoLogin.swift
//  app
//
//  Created by 조민기 on 10/6/24.
//

import Foundation
import KakaoSDKUser

class KakaoLogin: LoginDelegate {
    func login(complete result: LoginResult?) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk(completion: { oauthToken, error in
                result?(oauthToken?.accessToken, error)
            })
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                result?(oauthToken?.accessToken, error)
            }
        }
    }
}
