//
//  AppDependencies.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import Observation

enum AppConfig {
    static let apiBaseURL = "https://api.example.com"
    static let paymentBaseURL = "https://payments.example.com"
}
@Observable
final class AppDependencies {
    let networkClient: NetworkClient
    let paymentClient: NetworkClient
    
    let loginService: LoginServiceProtocol
    let feedService: FeedsServiceProtocol
    let paymentService: PaymentServiceProtocol

    init(networkClient: NetworkClient = NetworkClient(baseURL: AppConfig.apiBaseURL),
         paymentClient: NetworkClient = NetworkClient(baseURL: AppConfig.paymentBaseURL)) {
        self.networkClient = networkClient
        self.paymentClient = paymentClient
        
        self.loginService = LoginService(networkClient: networkClient)
        self.feedService = FeedsService(networkClient: networkClient)
        self.paymentService = PaymentService(networkClient: paymentClient)
    }
}
