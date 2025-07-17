//
//  DashboardView.swift
//  GithubClone
//
//  Created by Soumya Mishra on 17/07/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var vm = DashboardViewModel()
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                
                // MARK: - Profile Header
                if let user = vm.user {
                    HStack(alignment: .center, spacing: 12) {
                        AsyncImage(url: URL(string: user.avatar_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.login)
                                .font(.headline)
                            
                            Text(user.bio ?? "No bio")
                                .font(.subheadline)
                                .lineLimit(2)
                            
                            Text("Repos: \(user.public_repos ?? 0)")
                                .font(.subheadline)
                            
                            NavigationLink("Overview", destination: UserProfileView(username: user.login))
                                .font(.subheadline)
                                .padding(.top, 4)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                }
                
                // MARK: - Search Bar
                TextField("Search GitHub users", text: $vm.searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .focused($isSearchFocused)
                    .onChange(of: vm.searchQuery) { _, _ in
                        if vm.searchQuery.isEmpty {
                            vm.clearSearch()
                        } else {
                            vm.searchUser()
                        }
                    }
                    .padding(.horizontal)
                
                // MARK: - Repositories Title
                Text("Repositories")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                
                // MARK: - Search & Repository List
                List {
                    /// Loading State
                    if vm.isSearching {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    /// Search Results
                    else if !vm.searchResults.isEmpty {
                        Section(header: Text("Search Results")) {
                            ForEach(vm.searchResults) { user in
                                NavigationLink(destination: UserProfileView(username: user.login)) {
                                    HStack {
                                        AsyncImage(url: URL(string: user.avatar_url)) { img in
                                            img.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        
                                        Text(user.login)
                                            .font(.subheadline)
                                            .padding(.leading, 8)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    
                    /// My Repositories
                    else {
                        ForEach(vm.myRepos) { repo in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(repo.name)
                                    .font(.headline)
                                
                                Text(repo.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(repo.stargazers_count > 0 ? .yellow : .gray)
                                    
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
                    
                    /// Error
                    if let error = vm.error {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .listStyle(.insetGrouped)
                .padding(.top, -12)
                .onTapGesture {
                    isSearchFocused = false
                }
            }
            .navigationTitle("GitHub")
            .onAppear { vm.load() }
        }
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}
