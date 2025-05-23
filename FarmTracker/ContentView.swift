//
//  ContentView.swift
//  FarmTracker
//
//  Created by Katy Bruinsma on 23/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = true // change to false when login is ready

    var body: some View {
        NavigationView {
            if isAuthenticated {
                DashboardView()
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
