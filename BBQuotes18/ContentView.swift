//
//  ContentView.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuoteView(show: "Breaking Bad")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem{
                    Label("Breakinng Bad", systemImage:"tortoise")
                }
            QuoteView(show: "Better Call Saul")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem{
                    Label("Better Call Saul", systemImage:"briefcase")
                }
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
