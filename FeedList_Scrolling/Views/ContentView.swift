//
//  ContentView.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppDependencies.self) var appDependencies
    
    var body: some View {
        VStack {
            LoginView(loginService: appDependencies.loginService)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
