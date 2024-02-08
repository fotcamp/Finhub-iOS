//
//  ContentView.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Webview(url: URL(string: "https://finhub-front-end.vercel.app/")!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
