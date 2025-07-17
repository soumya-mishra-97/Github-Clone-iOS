//
//  SplashView.swift
//  GithubClone
//
//  Created by Soumya Mishra on 17/07/25.
//

import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var textOpacity = 0.0

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image("github")
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .scaleEffect(logoScale)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: logoScale)


                Text("GitHub")
                    .font(.system(size: 35))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 0.8), value: textOpacity)
            }
        }
        .onAppear {
            animateSplash()
        }
    }

    private func animateSplash() {
        logoScale = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            textOpacity = 1.0
        }
    }
}
