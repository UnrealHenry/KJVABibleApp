import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var searchResults: [SearchResult] = []
    @Environment(\.bibleDataManager) private var bibleDataManager
    
    // MARK: - Search Result Model
    struct SearchResult: Identifiable {
        let id = UUID()
        let book: String
        let chapter: Int
        let verse: Int
        let text: String
    }
    
    // MARK: - Search Result Item View
    struct SearchResultItemView: View {
        let result: SearchResult
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Reference (Book Chapter:Verse)
                Text("\(result.book) \(result.chapter):\(result.verse)")
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.primary)
                
                // Verse text
                Text(result.text)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineLimit(3)
                    .lineSpacing(2)
            }
            .padding(AppTheme.Dimensions.spacing)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.Dimensions.cornerRadius)
            .shadow(
                color: AppTheme.Shadows.subtle.color,
                radius: AppTheme.Shadows.subtle.radius,
                x: AppTheme.Shadows.subtle.x,
                y: AppTheme.Shadows.subtle.y
            )
        }
    }
    
    // MARK: - Empty State View
    struct EmptyStateView: View {
        let searchText: String
        
        var body: some View {
            VStack(spacing: AppTheme.Dimensions.spacing) {
                if searchText.isEmpty {
                    // Initial state
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: AppTheme.Dimensions.largeIconSize))
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Text("Search the Bible")
                        .font(AppTheme.Typography.heading)
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Text("Enter a word or phrase to search")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                } else {
                    // No results state
                    Image(systemName: "magnifyingglass.circle")
                        .font(.system(size: AppTheme.Dimensions.largeIconSize))
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Text("No results found")
                        .font(AppTheme.Typography.heading)
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Text("Try a different search term")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppTheme.Dimensions.spacing * 2)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Search Bar
    struct SearchBarView: View {
        @Binding var searchText: String
        @Binding var isSearching: Bool
        let onSearch: () -> Void
        
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Colors.secondary)
                
                TextField("Search scriptures...", text: $searchText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .submitLabel(.search)
                    .onSubmit {
                        onSearch()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        isSearching = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                }
                
                if !searchText.isEmpty {
                    Button(action: {
                        onSearch()
                    }) {
                        Text("Search")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                    .padding(.leading, 8)
                }
            }
            .padding(AppTheme.Dimensions.smallSpacing)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Dimensions.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                    .stroke(AppTheme.Colors.divider, lineWidth: AppTheme.Dimensions.borderWidth)
            )
        }
    }
    
    // MARK: - Main View
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: AppTheme.Dimensions.smallSpacing) {
                        Text("Search Scriptures")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.invertedText)
                        
                        Text("Find verses by keywords")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.invertedText.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Gradients.primaryGradient)
                    
                    // Search bar
                    SearchBarView(
                        searchText: $searchText, 
                        isSearching: $isSearching, 
                        onSearch: performSearch
                    )
                    .padding()
                    
                    // Results or empty state
                    if isSearching {
                        // Loading indicator
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.secondary))
                            .scaleEffect(1.5)
                            .padding()
                    } else if !searchText.isEmpty && !searchResults.isEmpty {
                        // Results list
                        ScrollView {
                            VStack(spacing: AppTheme.Dimensions.spacing) {
                                ForEach(searchResults) { result in
                                    NavigationLink(destination: BibleTextView(
                                        bookName: result.book,
                                        chapter: result.chapter,
                                        initialVerse: result.verse
                                    )) {
                                        SearchResultItemView(result: result)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                            .padding(.bottom, AppTheme.Dimensions.spacing)
                        }
                    } else {
                        // Empty state
                        EmptyStateView(searchText: searchText)
                            .frame(maxHeight: .infinity)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Search Logic
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        searchResults = []
        
        // Simulate search with a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Get all books
            let allBooks = bibleDataManager.getAllBooks()
            
            // Search for matches
            var results: [SearchResult] = []
            
            for book in allBooks {
                if let bookData = bibleDataManager.getBook(book) {
                    for (chapterNum, chapter) in bookData.chapters {
                        for (verseNum, verseText) in chapter {
                            if let verse = Int(verseNum), 
                               verseText.lowercased().contains(searchText.lowercased()) {
                                results.append(SearchResult(
                                    book: book,
                                    chapter: chapterNum,
                                    verse: verse,
                                    text: verseText
                                ))
                                
                                // Limit results to 50 for performance
                                if results.count >= 50 {
                                    break
                                }
                            }
                        }
                        
                        if results.count >= 50 {
                            break
                        }
                    }
                    
                    if results.count >= 50 {
                        break
                    }
                }
            }
            
            searchResults = results
            isSearching = false
        }
    }
}

#Preview {
    SearchView()
        .environment(\.bibleDataManager, BibleDataManager.shared)
} 