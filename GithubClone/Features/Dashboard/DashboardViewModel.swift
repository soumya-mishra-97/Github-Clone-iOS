//
//  DashboardViewModel.swift
//  GithubClone
//
//  Created by Soumya Mishra on 17/07/25.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var myRepos: [Repository] = []
    @Published var user: User?
    @Published var error: String?
    
    @Published var searchQuery: String = ""
    @Published var searchResults: [User] = []
    @Published var isSearching = false
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Load Data
    func load() {
        let username = Constants.username
        
        /// Fetch user profile
        APIService.shared.fetch(Endpoints.userProfile(username))
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] (user: User) in
                self?.user = user
            })
            .store(in: &cancellables)
        
        /// Fetch user's repositories
        APIService.shared.fetch(Endpoints.userRepos(username))
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let err) = completion {
                    self?.error = err.localizedDescription
                }
            }, receiveValue: { [weak self] (repos: [Repository]) in
                self?.myRepos = repos
            })
            .store(in: &cancellables)
    }
    
    /// Searches for GitHub users
    func searchUser() {
        guard !searchQuery.isEmpty else { return }
        isSearching = true
        APIService.shared.fetch(Endpoints.searchUsers(searchQuery))
            .sink { [weak self] completion in
                self?.isSearching = false
                if case .failure(let err) = completion {
                    self?.error = err.localizedDescription
                }
            } receiveValue: { [weak self] (response: SearchUserResponse) in
                self?.searchResults = response.items
            }
            .store(in: &cancellables)
    }
    
    /// Clears current search results and resets the searching state.
    func clearSearch() {
        searchResults.removeAll()
        isSearching = false
    }
}
