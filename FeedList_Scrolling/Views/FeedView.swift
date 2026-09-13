//
//  FeedView.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import SwiftUI

struct FeedView: View {
    @State var viewModelFeeds: FeedsViewModel
    var userName: String
    private let prefetchThreshold = 2
    
    init(feedsService: FeedsServiceProtocol, userName: String) {
        _viewModelFeeds = State(initialValue: FeedsViewModel(feedService: feedsService))
        self.userName = userName
    }
    
    var body: some View {
        NavigationStack {
            switch viewModelFeeds.fetchState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView("Loading feeds.")
                
            case .loadedSuccess:
                feedlist
                
            case .loadingFailed:
                ContentUnavailableView("Feeds not aval", systemImage: "list.bullet")
            }
        }
    }
    
    var feedlist: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModelFeeds.feeds) { feed in
                    FeedRow(feed: feed)
                }
                ForEach(Array(viewModelFeeds.feeds.enumerated()), id: \.element.id) { (index, feed) in
                    FeedRow(feed: feed)
                        .onAppear{
                            let isNearEnd = index == viewModelFeeds.feeds.count - prefetchThreshold
                            guard isNearEnd else { return }
                            Task {
                                await viewModelFeeds.fetchFeeds()
                            }
                        }
                }
            }
        }
        .navigationTitle("Feeds")
        .task {
            await viewModelFeeds.fetchFeeds()
        }
    }
}

struct FeedRow: View {
    let feed: Feed
    
    var body: some View {
        VStack {
            HStack {
                // CachedImage(feed.url)
                
                VStack {
                    Text(feed.feedUserName)
                    Text(feed.feedBody)
                }
            }
        }
    }
}

