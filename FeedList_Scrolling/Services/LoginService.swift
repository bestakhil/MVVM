//
//  LoginService.swift
//  MVVM_Login
//
//  Created by Akhil Gupta on 9/10/26.
//
// SOLID - Interface Segregation: exposes only what LoginViewModel needs, not the full LoginService surface.
// SOLID - Dependency Inversion: LoginViewModel depends on this abstraction, not the concrete LoginService.

protocol LoginServiceProtocol {
    func login(userName: String, password: String) async throws -> LoginResponse?
    func updateFeed(feedId: String, feedBody: String) async throws -> UpdateFeed?
    func deleteFeed(feedId: String, feedBody: String) async throws -> DeleteFeedResponse?
}

final class LoginService: LoginServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func login(userName: String, password: String) async throws -> LoginResponse? {
        let request = LoginRequest(userName: userName, password: password)
        let loginResponse: LoginResponse? = try await self.networkClient.post(path: "/login", body: request)
        return loginResponse
    }
}
