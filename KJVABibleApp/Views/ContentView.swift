//
//  ContentView.swift
//  KJVABibleApp
//
//  Created by Henry Edmond Ramirez on 5/6/25.
//

import SwiftUI
import SwiftData

// DEPRECATED: This view's functionality has been integrated into BibleHomeView.
// Use BibleHomeView as the main content view of the app.
struct ContentView: View {
    var body: some View {
        // Redirecting to BibleHomeView
        BibleHomeView()
    }
}

#Preview {
    ContentView()
        .environment(\.bibleDataManager, MockBibleDataManager.mock)
}
