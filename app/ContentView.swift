//
//  ContentView.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Webview(url: URL(string: "http://finhub-front-end.vercel.app/")!).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
