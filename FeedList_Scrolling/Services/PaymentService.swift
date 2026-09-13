
//
//  Payment.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

protocol PaymentServiceProtocol {
    func makePayment(userId: String, amount: Double) async throws
}

final class PaymentService: PaymentServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func makePayment(userId: String, amount: Double) async throws {
        
    }
}
