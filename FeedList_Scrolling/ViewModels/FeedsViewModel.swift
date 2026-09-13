//
//  ViewModelFeeds.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//
import Observation
import Foundation

enum FetchState: Hashable {
    case idle, loading, loadedSuccess, loadingFailed
}

@Observable
@MainActor

final class FeedsViewModel {
    let feedService: FeedsServiceProtocol
    var fetchState: FetchState = .idle
    var feeds = [Feed]()
    var nextCursor: String? = nil
    var hasmoreFeeds = true
    var errorDescn = ""
    
    
    init(feedService: FeedsServiceProtocol) {
        self.feedService = feedService
    }
    
    func fetchFeeds() async  {
        guard hasmoreFeeds  else { return }
        fetchState = .loading
        do {
            
            let feedPage: FeedPage = try await self.feedService.getFeeds(cursor: nextCursor)
            feeds += feedPage.feeds
            nextCursor = feedPage.nextCursor
            hasmoreFeeds = nextCursor != nil
            fetchState = .loadedSuccess
        } catch {
            print(error.localizedDescription)
            errorDescn = error.localizedDescription
            fetchState = .loadingFailed
        }
    }
}
