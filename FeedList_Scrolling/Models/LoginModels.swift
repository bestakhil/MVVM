//
//  LoginModels.swift
//  MVVM_Login
//
//  Created by Akhil Gupta on 9/10/26.
//

import Foundation

struct LoginRequest: Encodable {
    let userName, password: String
}

struct LoginResponse: Decodable, Hashable {
    let feeds: [Feed]?
    let userName: String?
    var error: String? = nil
}


