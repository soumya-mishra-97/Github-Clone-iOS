//
//  UserProfileView.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//

import SwiftUI

struct UserProfileView: View {
    let username: String
    @StateObject private var viewModel = UserProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                
                // MARK: - User Profile Info
                if let user = viewModel.user {
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: user.avatar_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        
                        Text(user.login)
                            .font(.title)
                        
                        Text(user.bio ?? "No bio available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 16) {
                            Text("Followers: \(user.followers ?? 0)")
                            Text("Repos: \(user.public_repos ?? 0)")
                        }
                        .font(.subheadline)
                        
                        Button(action: {
                            print("Edit Profile tapped")
                        }) {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                // MARK: - Pinned Repositories Title
                Text("📌 Pinned Repositories")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 4)
                
                // MARK: - Pinned Repositories List
                if !viewModel.pinnedRepos.isEmpty {
                    List {
                        ForEach(viewModel.pinnedRepos) { repo in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(repo.name)
                                    .font(.headline)
                                
                                Text(repo.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.yellow)
                                    
                                    Text("\(repo.stargazers_count)")
                                    
                                    if let lang = repo.language {
                                        Circle()
                                            .fill(.pink)
                                            .frame(width: 10, height: 10)
                                        Text(lang)
                                    }
                                }
                                .font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.top, -12)
                    .listStyle(.insetGrouped)
                }
                
                /// Loading or Error State
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.user == nil {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .navigationTitle("Overview")
            .onAppear {
                viewModel.fetchUser(username: username)
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(username: Constants.username)
            .preferredColorScheme(.dark)
    }
}
