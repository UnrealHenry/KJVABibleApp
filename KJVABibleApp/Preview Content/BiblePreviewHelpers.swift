import SwiftUI

// Preview Helper for SwiftUI previews
struct PreviewBibleHomeView: View {
    var body: some View {
        BibleHomeView()
            .environment(\.bibleDataManager, MockBibleDataManager.mock)
    }
}

// Preview Helper for BibleTextView
struct PreviewBibleTextView: View {
    var body: some View {
        BibleTextView(bookName: "Genesis", chapter: 1)
            .environment(\.bibleDataManager, MockBibleDataManager.mock)
    }
}

// Preview Helper for Apocrypha BibleTextView
struct PreviewApocryphaTextView: View {
    var body: some View {
        BibleTextView(bookName: "Tobit", chapter: 1)
            .environment(\.bibleDataManager, MockBibleDataManager.mock)
    }
} 