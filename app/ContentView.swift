//
//  ContentView.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        Webview(url: URL(string: "http://finhub-front-end.vercel.app/")!)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                self.keyboardHeight = 0
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
