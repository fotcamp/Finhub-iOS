//
//  Coordinator.swift
//  app
//
//  Created by 조민기 on 4/6/24.
//

import Foundation
import UIKit

enum SwiftSupport {
    static var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        let scenes = UIApplication.shared.connectedScenes
            .compactMap({ scene in
                return scene as? UIWindowScene
            })
        
        for scene in scenes {
            keyWindow = scene.windows.first { window in
                return window.isKeyWindow
            }
            
            if keyWindow != nil {
                break
            }
        }
        
        return keyWindow
    }
    
    static var topViewController: UIViewController? {
        get {
            guard let keyWindow = keyWindow else { return nil }
            
            return keyWindow.rootViewController
        }
    }
}
