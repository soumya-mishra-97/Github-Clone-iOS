//
//  NetworkError.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//

enum NetworkError: Error {
    case invalidURL, invalidResponse, decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Server error"
        case .decodingError: return "Parsing error"
        }
    }
}
