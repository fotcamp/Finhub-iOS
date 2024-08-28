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
    
    private var failedJson: JSON {
        get {
            var json = JSON()
            json.put(key: "result", value: "error")
            
            return json
        }
    }
    
    private var successJson: JSON {
        get {
            var json = JSON()
            json.put(key: "result", value: "success")
            
            return json
        }
    }
    
    func ready() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        settings.minimumFetchInterval = 60
        remoteConfig.configSettings = settings
    }
    
    func get(complete: @escaping (JSON) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        remoteConfig.fetch() { [weak self] (status, error) -> Void in
            guard let self = self else { return }
            
            guard status == .success else {
                self.returnFailedRemoteConfig(error: error, complete: complete)
                return
            }
            
            self.getConfig(complete: complete)
        }
    }
    
    private func getConfig(complete: @escaping (JSON) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.activate() { [weak self] (changed, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.returnFailedRemoteConfig(error: error, complete: complete)
                return
            }
            
            var json = successJson
            json.put(key: "config", value: getConfigJSON())
            
            complete(json)
        }
    }
    
    private func getConfigJSON() -> JSON {
        let remoteConfig = RemoteConfig.remoteConfig()
        var json = JSON()
        
        let configs = remoteConfig.keys(withPrefix: nil).map { key in (key: key, value: remoteConfig[key].stringValue)}
        for config in configs {
            json.put(key: config.key, value: config.value ?? "")
        }
        
        return json
    }
    
    private func returnFailedRemoteConfig(error: Error?, complete: @escaping (JSON) -> Void) {
        var json = failedJson
        
        if let error = error {
            json.put(key: "resultMsg", value: error.localizedDescription)
        }
        
        complete(json)
    }
}
