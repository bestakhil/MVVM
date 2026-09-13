//
//  NetworkClient.swift
//  MVVM_Login
//
//  Created by Akhil Gupta on 9/10/26.
//

import Foundation



actor NetworkClient {
    
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
        
    enum NetworkClientError: Error {
        case invalidURL
        case badresponse
    }
    
    let encoder = JSONEncoder()
    struct EmptyResponse: Decodable {
        
    }
    
    //Parse string Date and coverts this string Date into Swift Date.
    let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    
    func makeRequest<T: Decodable>(
        path: String,
        httpMethod: String,
        body: Encodable? = nil,
        queryParams: [String: String]? = nil,
        headers: [String: String]? = nil) async throws -> T {
            
            guard !path.isEmpty else {
                throw NetworkClientError.invalidURL
            }
            
            guard var urlComponents = URLComponents(string: baseURL + path) else {
                throw NetworkClientError.invalidURL
            }
            
            if let queryItems = queryParams, !queryItems.isEmpty {
                urlComponents.queryItems = queryItems.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
            }
            
            guard let requestURL = urlComponents.url else {
                throw NetworkClientError.invalidURL
            }
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = httpMethod
            
            headers?.forEach{
                urlRequest.setValue($1, forHTTPHeaderField: $0)
            }
            
            if let body {
                urlRequest.httpBody = try encoder.encode(body)
            }
            
            let (data, resp) = try await URLSession.shared.data(for: urlRequest)
            guard let httpURLResponse = resp as? HTTPURLResponse, (200...299).contains(httpURLResponse.statusCode) else {
                throw NetworkClientError.badresponse
            }
            return try decoder.decode(T.self, from: data)
        }
    
    
    func makeDefaultRequest<T: Decodable>(path: String) async throws -> T {
        guard !path.isEmpty else {
            throw NetworkClientError.invalidURL
        }
        guard let url = URL(string: baseURL + path) else {
            throw NetworkClientError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpURLResponse = response as? HTTPURLResponse, (200...299).contains(httpURLResponse.statusCode) else {
            throw NetworkClientError.badresponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func get<T: Decodable>(path: String,
                           queryParams: [String: String]? = nil,
                           headers: [String: String]? = nil) async throws -> T {
        
        return try await makeRequest(path: path, httpMethod: "GET", queryParams: queryParams)
    }
    
    func post<T: Decodable>(path: String,
                            httpMethod: String = "POST",
                            body: Encodable? = nil,
                            queryParams: [String: String]? = nil,
                            headers: [String: String]? = nil) async throws -> T {
        
        return try await makeRequest(path: path, httpMethod: httpMethod, body: body, queryParams: queryParams, headers: headers)
    }
    
    func put<T: Decodable>(path: String,
                           httpMethod: String = "PUT",
                           body: Encodable? = nil,
                           queryParams: [String: String]? = nil,
                           headers: [String: String]? = nil) async throws -> T {
        
        return try await makeRequest(path: path, httpMethod: httpMethod, body: body, queryParams: queryParams, headers: headers)
    }
    
    func delete<T: Decodable>(path: String,
                              httpMethod: String = "DELETE",
                              body: Encodable? = nil,
                              queryParams: [String: String]? = nil,
                              headers: [String: String]? = nil) async throws -> T {
        
        return try await makeRequest(path: path, httpMethod: httpMethod, body: body, queryParams: queryParams, headers: headers)
    }
    
    func delete(path: String,
                httpMethod: String,
                body: Encodable? = nil,
                queryParams: [String: String]? = nil,
                headers: [String: String]? = nil) async throws {
        
        let _: EmptyResponse = try await makeRequest(path: path, httpMethod: "DELETE", body: body, queryParams: queryParams, headers: headers)
    }
}
