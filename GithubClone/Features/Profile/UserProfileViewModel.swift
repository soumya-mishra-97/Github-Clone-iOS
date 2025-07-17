//
//  UserProfileViewModel.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//

import Foundation
import Combine

final class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var pinnedRepos: [Repository] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUser(username: String) {
        /// Fetch User Profile
        APIService.shared.fetch(Endpoints.userProfile(username))
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
        
        /// Fetch Repositories
        APIService.shared.fetch(Endpoints.userRepos(username))
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] (repos: [Repository]) in
                self?.pinnedRepos = repos
                    .sorted(by: { $0.stargazers_count > $1.stargazers_count })
                    .prefix(3)
                    .map { $0 }
            }
            .store(in: &cancellables)
    }
}
