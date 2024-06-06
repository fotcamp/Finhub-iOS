//
//  FinhubWebView.swift
//  app
//
//  Created by 조민기 on 3/17/24.
//

import Foundation
import WebKit

class FinhubWebView: WKWebView {
    var accessoryView: UIView?
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
}
