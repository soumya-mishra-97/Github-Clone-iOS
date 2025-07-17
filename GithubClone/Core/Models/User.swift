//
//  User.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//

// MARK: - GitHub user profile
struct User: Decodable, Identifiable {
    var id: Int { login.hashValue }
    let login: String
    let avatar_url: String
    let bio: String?
    let followers: Int?
    let public_repos: Int?
    var pinned: [Repository]?
}

// MARK: - GitHub repository
struct Repository: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
    let language: String?
}

// MARK: - Search results
struct SearchUserResponse: Decodable {
    let items: [User]
}
