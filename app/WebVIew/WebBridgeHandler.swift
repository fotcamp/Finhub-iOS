//
//  BridgeHandler.swift
//  app
//
//  Created by 조민기 on 4/6/24.
//

import Foundation
import WebKit

protocol WebBridgeDelegate: NSObjectProtocol {
    func callbackWeb(callbackId: String, data: String?)
}

class WebBridgeHandler: NSObject {
    weak var delegate: WebBridgeDelegate?
    
    init(_ delegate: WebBridgeDelegate? = nil) {
        self.delegate = delegate
    }
    
    func run(action: String, dic: JSON?) {
        self.perform(Selector(action + ":"), with: dic)
    }
}

extension WebBridgeHandler {
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
        
        if let callbackId = json.getString("callbackId") {
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
        
        if let callbackId = json.getString("callbackId") {
            delegate?.callbackWeb(callbackId: callbackId, data: data.toJsonString)
        }
    }
    
    @objc func setSafeAreaBackgroundColor(_ json: JSON) {
        if let color = json.getString("val2") {
            SwiftSupport.topViewController?.view.backgroundColor = UIColor.create(color)
        }
    }
}
