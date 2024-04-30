//
//  ContentView.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI

struct ContentView: View {
    let BASE_URL: String
    
    @State private var keyboardHeight: CGFloat
    @State private var url: String
    
    init() {
        self.BASE_URL = "http://localhost:3000/"//"http://finhub-front-end.vercel.app/"
        
        self.keyboardHeight = 0
        self.url = BASE_URL
    }
    
    var body: some View {
        ZStack {
            
            Webview(url: URL(string: url)!)
//                .edgesIgnoringSafeArea(.all)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.keyboardHeight = keyboardFrame.height
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    self.keyboardHeight = 0
                }
                .onReceive(NotificationCenter.default.publisher(for: .push), perform: { notification in
                    if let data = notification.userInfo?["data"] as? String,
                       let json = data.convertToDictionary() {
                        
                        if let view = json.getString("view") {
                            url = BASE_URL + view
                        }
                    }
                })
            Text(url)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
