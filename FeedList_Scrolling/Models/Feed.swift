//
//  Feed.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import Foundation

struct Feed : Decodable, Identifiable, Hashable {
    let feedId: Int
    var id:Int {
        feedId
    }
    let body: String
    let imageUrl: URL?
    let author: Author?
}

struct Author: Decodable, Hashable {
    let id: Int
    let name: String
    let username: String
    let avatarUrl: URL?
}

struct FeedPage: Decodable,Sendable {
    let feeds: [Feed]
    let nextCursor: String?
}

struct UpdateFeed : Codable {
    let feedId: String
    let feedBody: String?
    var feedError: String? = nil
}

struct DeleteFeed : Codable {
    let feedId: String
    let feedBody: String?
}

struct DeleteFeedResponse : Codable {
    let feedId: String
    var deleteFeedError: String? = nil
}
