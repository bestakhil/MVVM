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
    
    
    func fetchFeedsLocal() async {
        fetchState = .loading
        guard let fileUrl = Bundle.main.url(forResource: "feed", withExtension: "json") else {
            fetchState = .loadingFailed
            return
        }
        do {
            let data = try await Task.detached(priority: .userInitiated) {
                try Data(contentsOf: fileUrl)
            }.value
            feeds = try JSONDecoder().decode([Feed].self, from: data)
            nextCursor = nil
            fetchState = .loadedSuccess
        } catch {
            errorDescn = error.localizedDescription
            fetchState = .loadingFailed
        }
    }
}
