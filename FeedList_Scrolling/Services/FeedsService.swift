//
//  FeedsService.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

protocol FeedsServiceProtocol {
    func getFeeds(cursor: String?) async throws -> FeedPage
    func updateFeed(feedId: String, feedBody: String) async throws ->  UpdateFeed?
    func deleteFeed(feedId: String, feedBody: String) async throws ->  DeleteFeedResponse?
}

final class FeedsService: FeedsServiceProtocol {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getFeeds(cursor: String?) async throws -> FeedPage {
        var queryParams = ["limit": String(10)]
        if let cursor {
            queryParams["cursor"] = cursor
        }
        let feedPage: FeedPage = try await self.networkClient.get(path: "/feeds", queryParams: queryParams)
        return feedPage
    }
    
    func updateFeed(feedId: String, feedBody: String) async throws ->  UpdateFeed? {
        let request = UpdateFeed(feedId: feedId, feedBody: feedBody)
        let updateResponse: UpdateFeed? = try await self.networkClient.put(path: "/updatepost", body: request)
        return updateResponse
    }
    
    func deleteFeed(feedId: String, feedBody: String) async throws ->  DeleteFeedResponse? {
        let request = DeleteFeed(feedId: feedId, feedBody: feedBody)
        let updateResponse: DeleteFeedResponse? = try await self.networkClient.delete(path: "/deletepost", body: request)
        return updateResponse
    }
}
