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
        webview.scrollView.bounces = false
        webview.allowsBackForwardNavigationGestures = true
        
        if #available(iOS 16.4, *) {
//            #if DEBUG
                webview.isInspectable = true
//            #endif
        }
        
        webview.configuration.userContentController.add(WebViewContentController(webview), name: "jsToNative")
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

class WebViewContentController: NSObject, WKScriptMessageHandler {
    weak var webView: FinhubWebView?
    
    init(_ webView: FinhubWebView) {
        self.webView = webView
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(name)
        if message.name == "jsToNative" {
            if let body = message.body as? String {
                print(body)
                
                let handler = WebBridgeHandler(self)
                
                if let dic = convertToDictionary(text: body), let action = dic["val1"] as? String {
                    handler.run(action: action, dic: dic)
                }
            }
        }
    }
    
    func convertToDictionary(text: String) -> JSON? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension WebViewContentController: WebBridgeDelegate {
    func callbackWeb(callbackId: String, data: String?) {
        let dataString = data?.replacingOccurrences(of: "'", with: "\\'") ?? ""

        let jsCode = "window.dispatchEvent(new CustomEvent('\(callbackId)', { detail: '\(dataString)' }));"
        
        self.webView?.evaluateJavaScript(jsCode) { result, error in
            if let error = error {
                print("Error dispatching event in WebView: \(error)")
            } else {
                print("Event dispatched successfully with data: \(dataString)")
            }
        }
    }
}
