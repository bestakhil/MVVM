//
//  FeedView.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import SwiftUI

struct FeedView: View {
    @State var viewModelFeeds: FeedsViewModel
    @AppStorage("mockMode") var mockMode = false
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
        .task {
            if mockMode {
                await viewModelFeeds.fetchFeedsLocal()
            } else {
                await viewModelFeeds.fetchFeeds()
            }
        }
    }
    
    var feedlist: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(viewModelFeeds.feeds.enumerated()), id: \.element.id) { (index, feed) in
                    FeedRow(feed: feed)
                        .onAppear {
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
        
    }
}

struct FeedRow: View {
    let feed: Feed
    
    var body: some View {
        VStack {
            HStack {
                if let imageURL = feed.author?.avatarUrl {
                    CachedImage(imageUrl: imageURL)
                }
                
                VStack {
                    Text(feed.body)
                }
            }
            
            Rectangle()
                .frame(height: 1)
        }
        .padding([.bottom, .horizontal], 5)
    }
}

struct CachedImage: View {
    var imageUrl: URL
    @State var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
                    .frame(width: 70, height: 70)
            } else {
                ProgressView("Loading image..")
            }
        }
        .task(id: imageUrl) {
            image = await ImageLoader.shared.loadImage(imageURL: imageUrl)
        }
    }
}
