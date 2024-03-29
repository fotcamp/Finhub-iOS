//
//  Webview.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    let url: URL
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = FinhubWebView()
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.scrollView.maximumZoomScale = 1.0
        webview.scrollView.minimumZoomScale = 1.0
        webview.allowsBackForwardNavigationGestures = true
        
        if #available(iOS 16.4, *) {
//            #if DEBUG
                webview.isInspectable = true
//            #endif
        }
        
        webview.insetsLayoutMarginsFromSafeArea = false
        
        webview.scrollView.contentInset = .zero
        
        webview.load(request)
        return webview
    }
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.scrollView.maximumZoomScale = 1.0
        webview.scrollView.minimumZoomScale = 1.0
        webview.allowsBackForwardNavigationGestures = true
        
        if #available(iOS 16.4, *) {
//            #if DEBUG
                webview.isInspectable = true
//            #endif
        }
        
        webview.scrollView.contentInsetAdjustmentBehavior = .never
        
        webview.load(request)
    }
}

struct Webview_Previews: PreviewProvider {
    static var previews: some View {
        Webview(url: URL(string: "https://finhub-front-end.vercel.app/")!)
    }
}

