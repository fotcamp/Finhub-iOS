//
//  SceneDelegate.swift
//  app
//
//  Created by 조민기 on 3/10/24.
//

import Foundation
import UIKit
import KakaoSDKAuth

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let userInfo = connectionOptions.notificationResponse?.notification.request.content.userInfo as? JSON
        else { return }
        
        if let view = userInfo.getString("view") {
            Static.viewUrl = view
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SwiftSupport.sendNotification(data: userInfo.toJsonString)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
