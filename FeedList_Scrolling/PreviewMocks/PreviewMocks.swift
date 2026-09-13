// PreviewMocks.swift
// Default no-op implementations for all service protocols.
// Mocks only need to override what they care about.

#if DEBUG
extension LoginServiceProtocol {
    func login(userName: String, password: String) async throws -> LoginResponse? { nil }
    func updateFeed(feedId: String, feedBody: String) async throws -> UpdateFeed? { nil }
    func deleteFeed(feedId: String, feedBody: String) async throws -> DeleteFeedResponse? { nil }
}

extension FeedsServiceProtocol {
    func getFeeds() async throws -> [Feed]? { [] }
}

extension PaymentServiceProtocol {
    func makePayment(userId: String, amount: Double) async throws {}
}
#endif
