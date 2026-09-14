//
//  ContentView.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppDependencies.self) var appDependencies
    @AppStorage("rememberMe") private var rememberMe = false
    @AppStorage("savedUserName") private var savedUserName = ""
    @AppStorage("savedPassword") private var savedPassword = ""

    var body: some View {
        if rememberMe && !savedUserName.isEmpty {
            FeedView(feedsService: appDependencies.feedService, userName: savedUserName)
        } else {
            LoginView(loginService: appDependencies.loginService)
        }
    }
}

#Preview {
    ContentView()
}
