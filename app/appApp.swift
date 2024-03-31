//
//  appApp.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI

@main
struct appApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
