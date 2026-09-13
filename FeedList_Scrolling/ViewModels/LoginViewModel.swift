//
//  LoginViewModel.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import Observation
import Foundation

@Observable
@MainActor

final class LoginViewModel {
    let loginService: LoginServiceProtocol
    
    var errorMessage: String?
    var loginResponse: LoginResponse?
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
    }
    
    func login(username: String, password: String) async {
        do {
            loginResponse = try await loginService.login(userName: username, password: password)
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
}
