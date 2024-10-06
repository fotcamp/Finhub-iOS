//
//  BridgeHandler.swift
//  app
//
//  Created by 조민기 on 4/6/24.
//

import Foundation
import WebKit
import FirebaseMessaging
import FirebaseRemoteConfig
import KakaoSDKUser
import GoogleSignIn

protocol WebBridgeDelegate: NSObjectProtocol {
    func callbackWeb(callbackId: String, data: String?)
}

class WebBridgeHandler: NSObject {
    weak var delegate: WebBridgeDelegate?
    private var loginDelegate: LoginDelegate?
    
    init(_ delegate: WebBridgeDelegate? = nil) {
        self.delegate = delegate
    }
    
    func run(action: String, dic: JSON?) {
        self.perform(Selector(action + ":"), with: dic)
    }
}

extension WebBridgeHandler {
    private func getCallback(_ json: JSON) -> String? {
        return json.getString("callbackId")
    }
    
    @objc func share(_ json: JSON) {
        let urlString = json.getString("val2") ?? ""
        let activityViewController = UIActivityViewController(activityItems: [urlString], applicationActivities: nil)
        let viewController = SwiftSupport.topViewController
        
        activityViewController.popoverPresentationController?.sourceView = viewController?.view
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func appVersion(_ json: JSON) {
        var version = ""
        
        if let info = Bundle.main.infoDictionary,
           let v = info["CFBundleShortVersionString"] as? String {
            version = v
        }
        
        if let callbackId = getCallback(json) {
            delegate?.callbackWeb(callbackId: callbackId, data: version)
        }
    }
    
    @objc func getSafeAreaInset(_ json: JSON) {
        let window = SwiftSupport.keyWindow
        let data: [String : Any] = [
            "top": window?.safeAreaInsets.top ?? 0,
            "bottom": window?.safeAreaInsets.bottom ?? 0,
            "left": window?.safeAreaInsets.left ?? 0,
            "right": window?.safeAreaInsets.right ?? 0
        ]
        
        if let callbackId = getCallback(json) {
            delegate?.callbackWeb(callbackId: callbackId, data: data.toJsonString)
        }
    }
    
    @objc func setSafeAreaBackgroundColor(_ json: JSON) {
        if let color = json.getString("val2") {
            SwiftSupport.topViewController?.view.backgroundColor = UIColor.create(color)
        }
    }
    
    @objc func getPushToken(_ json: JSON) {
        guard let callback = getCallback(json) else { return }
        
        Messaging.messaging().token { [weak self] token, error in
            guard let token = token else { return }
            self?.delegate?.callbackWeb(callbackId: callback, data: token)
        }
    }
    
    @objc func getRemoteConfig(_ json: JSON) {
        guard
            let callback = getCallback(json)
        else { return }
        
        FinhubRemoteConfig.shared.get() { [weak self] value in
            self?.delegate?.callbackWeb(callbackId: callback, data: value.toJsonString)
        }
    }
    
    @objc func getNotificationPermission(_ json: JSON) {
        guard let callback = getCallback(json) else { return }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { [weak self] granted, error in
            let result: JSON = ["result": granted]
            self?.delegate?.callbackWeb(callbackId: callback, data: result.toJsonString)
        })
    }
    
    @objc func requestNotificationPermission(_ json: JSON) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @objc func loginKakao(_ json: JSON) {
        guard let callback = getCallback(json) else { return }
        
        loginDelegate = KakaoLogin()
        login(callback: callback)
    }
    
    @objc func loginGoogle(_ json: JSON) {
        guard let _ = SwiftSupport.topViewController,
              let callback = getCallback(json)
        else { return }
        
        loginDelegate = GoogleLogin()
        login(callback: callback)
    }
    
    @objc func loginApple(_ json: JSON) {
        // TODO
    }
    
    private func login(callback: String) {
        loginDelegate?.login { [weak self] token, error in
            guard let self = self else { return }
            
            var result: JSON = [:]
            
            if let error = error {
                result = [
                    "result": "error",
                    "msg": error.localizedDescription
                ]
            }
            else if let token = token {
                result = [
                    "result": "success",
                    "token": token
                ]
            }
            else {
                result = [
                    "result": "failed",
                    "msg": "로그인 실패"
                ]
            }
            
            self.delegate?.callbackWeb(callbackId: callback, data: result.toJsonString)
        }
    }
}
