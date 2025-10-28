import SwiftUI

struct BibleTextView: View {
    let bookName: String
    let chapter: Int
    let initialVerse: Int
    @State private var selectedVerse: Int? = nil
    @State private var showVerseSelection = false
    @State private var fontSize: CGFloat = 16
    @State private var showFontControls = false
    @State private var showVerseNumbers = true
    @State private var showShare = false
    @State private var shareText = ""
    @StateObject private var bookmarkManager = BookmarkManager.shared
    @Environment(\.bibleDataManager) private var bibleDataManager
    @Environment(\.dismiss) private var dismiss
    
    init(bookName: String, chapter: Int, initialVerse: Int = 1) {
        self.bookName = bookName
        self.chapter = chapter
        self.initialVerse = initialVerse
    }
    
    // Cache for verse text
    @State private var verseTextCache: [Int: String] = [:]
    
    private func getVerseText(_ verse: Int) -> String? {
        if let cachedText = verseTextCache[verse] {
            return cachedText
        }
        let text = bibleDataManager.getVerse(book: bookName, chapter: chapter, verse: verse)
        if let text = text {
            verseTextCache[verse] = text
        }
        return text
    }
    
    // MARK: - Verse Components
    struct FirstVerseView: View {
        let bookName: String
        let chapter: Int
        let verse: Int
        let text: String
        let fontSize: CGFloat
        let showVerseNumber: Bool
        let isHighlighted: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Chapter heading
                Text(bookName)
                    .font(AppTheme.Typography.heading)
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text("Chapter \(chapter)")
                    .font(AppTheme.Typography.chapterNumberFont)
                    .foregroundColor(AppTheme.Colors.chapterNumber)
                    .padding(.bottom, 8)
                
                // First verse
                HStack(alignment: .top, spacing: 4) {
                    if showVerseNumber {
                        Text("\(verse)")
                            .font(AppTheme.Typography.verseNumberFont)
                            .foregroundColor(AppTheme.Colors.verseNumber)
                            .padding(.trailing, 2)
                    }
                    
                    Text(text)
                        .font(.custom("Baskerville", size: fontSize))
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .padding(.vertical, 4)
                }
                .padding(isHighlighted ? 8 : 0)
                .background(isHighlighted ? AppTheme.Colors.highlight : Color.clear)
                .cornerRadius(isHighlighted ? AppTheme.Dimensions.smallCornerRadius : 0)
            }
        }
    }
    
    struct VerseView: View {
        let verse: Int
        let text: String
        let fontSize: CGFloat
        let showVerseNumber: Bool
        let isHighlighted: Bool
        
        var body: some View {
            HStack(alignment: .top, spacing: 4) {
                if showVerseNumber {
                    Text("\(verse)")
                        .font(AppTheme.Typography.verseNumberFont)
                        .foregroundColor(AppTheme.Colors.verseNumber)
                        .padding(.trailing, 2)
                }
                
                Text(text)
                    .font(.custom("Baskerville", size: fontSize))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .padding(.vertical, 4)
            }
            .padding(isHighlighted ? 8 : 0)
            .background(isHighlighted ? AppTheme.Colors.highlight : Color.clear)
            .cornerRadius(isHighlighted ? AppTheme.Dimensions.smallCornerRadius : 0)
        }
    }
    
    // MARK: - Toolbar Components
    private var fontControls: some View {
        HStack(spacing: 12) {
            Button(action: {
                if fontSize > 12 {
                    fontSize -= 2
                }
            }) {
                Image(systemName: "textformat.size.smaller")
                    .foregroundColor(AppTheme.Colors.secondary)
            }
            
            Text("\(Int(fontSize))")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            Button(action: {
                if fontSize < 24 {
                    fontSize += 2
                }
            }) {
                Image(systemName: "textformat.size.larger")
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }
        .padding(8)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Dimensions.smallCornerRadius)
        .shadow(color: AppTheme.Shadows.subtle.color, radius: 3, x: 0, y: 2)
    }
    
    private var verseSelector: some View {
        Button(action: {
            showVerseSelection.toggle()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "text.quote")
                Text("Verse")
            }
            .font(AppTheme.Typography.caption)
            .foregroundColor(AppTheme.Colors.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(AppTheme.Colors.surface)
            )
            .overlay(
                Capsule()
                    .stroke(AppTheme.Colors.secondary.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Verse Selection View
    struct VerseSelectionView: View {
        let bookName: String
        let chapter: Int
        let totalVerses: Int
        @Binding var selectedVerse: Int?
        @Binding var showVerseSelection: Bool
        @Environment(\.bibleDataManager) private var bibleDataManager
        
        var body: some View {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Select Verse")
                        .font(AppTheme.Typography.heading)
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        showVerseSelection = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                }
                
                Divider()
                    .background(AppTheme.Colors.divider)
                
                // Verse grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 50))
                    ], spacing: 8) {
                        ForEach(1...totalVerses, id: \.self) { verse in
                            Button(action: {
                                selectedVerse = verse
                                showVerseSelection = false
                            }) {
                                Text("\(verse)")
                                    .font(AppTheme.Typography.body)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(
                                        selectedVerse == verse 
                                        ? AppTheme.Colors.primary 
                                        : AppTheme.Colors.primaryText
                                    )
                                    .background(
                                        selectedVerse == verse
                                        ? AppTheme.Colors.primary.opacity(0.1)
                                        : AppTheme.Colors.surface
                                    )
                                    .cornerRadius(AppTheme.Dimensions.smallCornerRadius)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.Dimensions.smallCornerRadius)
                                            .stroke(
                                                selectedVerse == verse
                                                ? AppTheme.Colors.primary
                                                : AppTheme.Colors.divider,
                                                lineWidth: 1
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding()
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.Dimensions.cornerRadius)
            .shadow(
                color: AppTheme.Shadows.medium.color,
                radius: AppTheme.Shadows.medium.radius,
                x: AppTheme.Shadows.medium.x,
                y: AppTheme.Shadows.medium.y
            )
            .padding()
        }
    }
    
    // MARK: - Main View
    var body: some View {
        ZStack {
            // Background
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            // Scripture content
            VStack(spacing: 0) {
                // Toolbar
                HStack {
                    Button(action: {
                        showVerseNumbers.toggle()
                    }) {
                        Image(systemName: showVerseNumbers ? "number.square.fill" : "number.square")
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    
                    Spacer()
                    
                    // Version and Language mode indicator
                    if let dataManager = bibleDataManager as? BibleDataManager {
                        HStack(spacing: 4) {
                            // Version indicator
                            HStack(spacing: 3) {
                                Image(systemName: "book.closed")
                                    .font(.system(size: 12))
                                Text(dataManager.currentVersion == .kjv ? "KJV" : "RV")
                                    .font(AppTheme.Typography.small)
                            }
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(AppTheme.Colors.surface)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppTheme.Colors.divider, lineWidth: 1)
                            )
                            
                            // Language mode indicator (only for KJV)
                            if dataManager.currentVersion == .kjv && dataManager.useModernEnglish {
                                HStack(spacing: 3) {
                                    Image(systemName: "textformat")
                                        .font(.system(size: 12))
                                    Text("Modern")
                                        .font(AppTheme.Typography.small)
                                }
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(AppTheme.Colors.surface)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppTheme.Colors.divider, lineWidth: 1)
                                )
                            }
                        }
                    }
                    
                    verseSelector
                    
                    Spacer()
                    
                    Button(action: {
                        showFontControls.toggle()
                    }) {
                        Image(systemName: "textformat.size")
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(AppTheme.Colors.cardBackground)
                .shadow(color: AppTheme.Shadows.subtle.color, radius: 3, x: 0, y: 1)
                
                // Font size controls
                if showFontControls {
                    fontControls
                        .padding(.top, 8)
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Scripture text
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let firstVerseText = getVerseText(1) {
                            FirstVerseView(
                                bookName: bookName,
                                chapter: chapter,
                                verse: 1,
                                text: firstVerseText,
                                fontSize: fontSize,
                                showVerseNumber: showVerseNumbers,
                                isHighlighted: selectedVerse == 1
                            )
                            .padding(.top)
                            .id("verse-1")
                        }
                        
                        if let book = bibleDataManager.getBook(bookName),
                           let chapterVerses = book.chapters[chapter] {
                            
                            // Rest of the verses
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(2...chapterVerses.count, id: \.self) { verse in
                                    if let verseText = getVerseText(verse) {
                                        VerseView(
                                            verse: verse,
                                            text: verseText,
                                            fontSize: fontSize,
                                            showVerseNumber: showVerseNumbers,
                                            isHighlighted: selectedVerse == verse
                                        )
                                        .id("verse-\(verse)")
                                        .onTapGesture {
                                            selectedVerse = verse
                                        }
                                    }
                                }
                            }
                            
                            // Chapter end indicator
                            Text("End of Chapter \(chapter)")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.tertiaryText)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 24)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                
                // Actions toolbar
                HStack(spacing: 20) {
                    Spacer()
                    
                    Button(action: {
                        if let verseText = getVerseText(selectedVerse ?? 1) {
                            shareText = "\(bookName) \(chapter):\(selectedVerse ?? 1) - \(verseText)"
                            showShare = true
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    
                    Button(action: {
                        if let text = getVerseText(selectedVerse ?? 1) {
                            let bookmark = Bookmark(
                                bookName: bookName,
                                chapter: chapter,
                                verse: selectedVerse ?? 1,
                                text: text
                            )
                            bookmarkManager.addBookmark(bookmark)
                        }
                    }) {
                        Image(systemName: "bookmark")
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .background(AppTheme.Colors.cardBackground)
                .shadow(color: AppTheme.Shadows.subtle.color, radius: 3, x: 0, y: -1)
            }
            
            // Verse selection modal
            if showVerseSelection {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showVerseSelection = false
                    }
                
                VerseSelectionView(
                    bookName: bookName,
                    chapter: chapter,
                    totalVerses: bibleDataManager.getBook(bookName)?.chapters[chapter]?.count ?? 0,
                    selectedVerse: $selectedVerse,
                    showVerseSelection: $showVerseSelection
                )
                .frame(maxWidth: 400)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(AppTheme.Typography.body)
                    }
                    .foregroundColor(AppTheme.Colors.primary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("\(bookName) \(chapter)")
                    .font(AppTheme.Typography.heading)
                    .foregroundColor(AppTheme.Colors.primary)
            }
        }
        .sheet(isPresented: $showShare) {
            ActivityViewController(text: shareText)
        }
        .onAppear {
            // Scroll to initial verse if needed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if initialVerse > 1 {
                    selectedVerse = initialVerse
                    // Handle scrolling to the verse here
                }
            }
        }
    }
}

// MARK: - Activity View for Sharing
struct ActivityViewController: UIViewControllerRepresentable {
    let text: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        BibleTextView(bookName: "Genesis", chapter: 1)
            .environment(\.bibleDataManager, BibleDataManager.shared)
    }
} 