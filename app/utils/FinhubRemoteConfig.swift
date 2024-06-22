//
//  FinhubRemoteConfig.swift
//  app
//
//  Created by 조민기 on 6/22/24.
//

import Foundation
import FirebaseRemoteConfig

class FinhubRemoteConfig {
    static let shared = FinhubRemoteConfig()
    
    func ready() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        settings.minimumFetchInterval = 60
        remoteConfig.configSettings = settings
    }
    
    func get(key: String?, complete: @escaping (String) -> Void) {
        guard let key = key else { return }
        
        let remoteConfig = RemoteConfig.remoteConfig()
        
        remoteConfig.fetch() { (status, error) -> Void in
            guard status == .success else { return }
            
            remoteConfig.activate() { (changed, error) in
                guard let value = remoteConfig[key].stringValue else { return }
                complete(value)
            }
        }
    }
}
