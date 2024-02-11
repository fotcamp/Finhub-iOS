//
//  appApp.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI
import Firebase

@main
struct appApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
