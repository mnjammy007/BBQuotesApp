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
            FetchView(show: Constants.bbName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem{
                    Label(Constants.bbName, systemImage:"tortoise")
                }
            FetchView(show: Constants.bcsName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem{
                    Label(Constants.bcsName, systemImage:"briefcase")
                }
            FetchView(show: Constants.ecName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem{
                    Label(Constants.ecName, systemImage:"car")
                }

        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
