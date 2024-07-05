//
//  Webview.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    @Binding var url: String
    
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = FinhubWebView()
        webview.scrollView.maximumZoomScale = 1.0
        webview.scrollView.minimumZoomScale = 1.0
        webview.scrollView.bounces = false
        webview.allowsBackForwardNavigationGestures = true
        
#if DEBUG
        if #available(iOS 16.4, *) {
            webview.isInspectable = true
        }
#endif
        webview.configuration.userContentController.add(WebViewContentController(webview), name: "jsToNative")
        webview.navigationDelegate = context.coordinator
        
        webview.insetsLayoutMarginsFromSafeArea = false
        webview.scrollView.contentInset = .zero
        
        return webview
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(self)
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad)
        
        webview.load(request)
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var parent: Webview?
    
    init(_ parent: Webview) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}

class WebViewContentController: NSObject, WKScriptMessageHandler {
    weak var webView: FinhubWebView?
    var handler: WebBridgeHandler?
    
    init(_ webView: FinhubWebView) {
        self.webView = webView
        
        super.init()
        
        handler = WebBridgeHandler(self)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(name)
        if message.name == "jsToNative" {
            if let body = message.body as? String {
                print(body)
                
                if let dic = convertToDictionary(text: body), let action = dic["val1"] as? String {
                    handler?.run(action: action, dic: dic)
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
