//
//  KJVABibleAppApp.swift
//  KJVABibleApp
//
//  Created by Henry Edmond Ramirez on 5/6/25.
//

import SwiftUI

@main
struct KJVABibleAppApp: App {
    @StateObject private var bibleDataManager = BibleDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            BibleHomeView()
                .environment(\.bibleDataManager, bibleDataManager)
        }
    }
}
