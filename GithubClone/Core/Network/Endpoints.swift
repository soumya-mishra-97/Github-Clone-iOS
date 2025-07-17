//
//  Endpoints.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//


struct Endpoints {
    /// Base URL
    static let baseURL = "https://api.github.com"
    
    /// Search GitHub users
    static func searchUsers(_ query: String) -> String {
        "\(baseURL)/search/users?q=\(query)"
    }
    
    /// Fetch user profile details
    static func userProfile(_ username: String) -> String {
        "\(baseURL)/users/\(username)"
    }
    
    /// Fetch paginated repositories of a user
    static func userRepos(_ username: String, page: Int = 1) -> String {
        "\(baseURL)/users/\(username)/repos?page=\(page)&per_page=30"
    }
}
