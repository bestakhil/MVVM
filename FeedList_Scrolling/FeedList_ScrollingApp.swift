//
//  FeedList_ScrollingApp.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import SwiftUI

@main
struct FeedList_ScrollingApp: App {
    
    @State var dependecies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dependecies)
        }
    }
}
