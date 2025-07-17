//
//  GithubCloneApp.swift
//  GithubClone
//
//  Created by Soumya Mishra on 16/07/25.
//

import SwiftUI

@main
struct GithubCloneApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                } else {
                    DashboardView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                    }
                }
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
