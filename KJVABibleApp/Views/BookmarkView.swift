import SwiftUI

struct Bookmark: Identifiable, Codable {
    let id: UUID
    let bookName: String
    let chapter: Int
    let verse: Int
    let date: Date
    let text: String
    
    init(bookName: String, chapter: Int, verse: Int, text: String) {
        self.id = UUID()
        self.bookName = bookName
        self.chapter = chapter
        self.verse = verse
        self.date = Date()
        self.text = text
    }
}

class BookmarkManager: ObservableObject {
    static let shared = BookmarkManager()
    
    @Published var bookmarks: [Bookmark] = []
    
    init() {
        loadBookmarks()
    }
    
    func addBookmark(_ bookmark: Bookmark) {
        // Check for duplicates
        if !bookmarks.contains(where: { 
            $0.bookName == bookmark.bookName && 
            $0.chapter == bookmark.chapter && 
            $0.verse == bookmark.verse 
        }) {
            bookmarks.append(bookmark)
            saveBookmarks()
        }
    }
    
    func removeBookmark(_ bookmark: Bookmark) {
        bookmarks.removeAll { $0.id == bookmark.id }
        saveBookmarks()
    }
    
    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encoded, forKey: "bookmarks")
        }
    }
    
    private func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: "bookmarks"),
           let decoded = try? JSONDecoder().decode([Bookmark].self, from: data) {
            bookmarks = decoded
        }
    }
}

struct BookmarkView: View {
    @StateObject private var bookmarkManager = BookmarkManager.shared
    @State private var editMode: EditMode = .inactive
    @State private var selectedBookmarks: Set<UUID> = []
    
    // MARK: - Empty State View
    struct EmptyStateView: View {
        var body: some View {
            VStack(spacing: AppTheme.Dimensions.spacing) {
                Image(systemName: "bookmark.slash")
                    .font(.system(size: AppTheme.Dimensions.largeIconSize * 1.2))
                    .foregroundColor(AppTheme.Colors.secondary.opacity(0.7))
                    .padding(.bottom, AppTheme.Dimensions.smallSpacing)
                
                Text("No Bookmarks")
                    .font(AppTheme.Typography.heading)
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text("Your saved verses will appear here")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                
                Text("Tap the bookmark icon while reading to save a verse")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
                    .multilineTextAlignment(.center)
                    .padding(.top, AppTheme.Dimensions.smallSpacing)
            }
            .padding(AppTheme.Dimensions.spacing * 2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Bookmark Item View
    struct BookmarkItemView: View {
        let bookmark: Bookmark
        let isSelected: Bool
        let isEditing: Bool
        let onDelete: () -> Void
        
        var body: some View {
            HStack(alignment: .top) {
                if isEditing {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.tertiaryText)
                        .padding(.trailing, 4)
                        .padding(.top, 2)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // Reference
                    HStack {
                        Text("\(bookmark.bookName) \(bookmark.chapter):\(bookmark.verse)")
                            .font(AppTheme.Typography.bodyBold)
                            .foregroundColor(AppTheme.Colors.primary)
                        
                        Spacer()
                        
                        if !isEditing {
                            Menu {
                                Button(role: .destructive, action: onDelete) {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(AppTheme.Colors.tertiaryText)
                                    .padding(4)
                            }
                        }
                    }
                    
                    // Verse text
                    Text(bookmark.text)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .lineLimit(3)
                        .lineSpacing(2)
                    
                    // Date
                    Text(formattedDate(bookmark.date))
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
            }
            .padding(AppTheme.Dimensions.spacing)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                    .fill(isSelected ? AppTheme.Colors.primary.opacity(0.05) : AppTheme.Colors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                    .stroke(
                        isSelected ? AppTheme.Colors.primary.opacity(0.5) : AppTheme.Colors.divider,
                        lineWidth: AppTheme.Dimensions.borderWidth
                    )
            )
            .shadow(
                color: AppTheme.Shadows.subtle.color,
                radius: AppTheme.Shadows.subtle.radius,
                x: AppTheme.Shadows.subtle.x,
                y: AppTheme.Shadows.subtle.y
            )
        }
        
        private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return "Saved on \(formatter.string(from: date))"
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
                        Text("Bookmarks")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.invertedText)
                        
                        if !bookmarkManager.bookmarks.isEmpty {
                            Text("\(bookmarkManager.bookmarks.count) saved verses")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.invertedText.opacity(0.8))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Gradients.primaryGradient)
                    
                    // Bookmark list or empty state
                    if bookmarkManager.bookmarks.isEmpty {
                        EmptyStateView()
                    } else {
                        // Bookmark list
                        ScrollView {
                            VStack(spacing: AppTheme.Dimensions.spacing) {
                                ForEach(bookmarkManager.bookmarks) { bookmark in
                                    let isSelected = selectedBookmarks.contains(bookmark.id)
                                    
                                    if editMode.isEditing {
                                        BookmarkItemView(
                                            bookmark: bookmark,
                                            isSelected: isSelected,
                                            isEditing: true,
                                            onDelete: { deleteBookmark(bookmark) }
                                        )
                                        .onTapGesture {
                                            toggleSelection(bookmark)
                                        }
                                    } else {
                                        NavigationLink(destination: BibleTextView(
                                            bookName: bookmark.bookName,
                                            chapter: bookmark.chapter,
                                            initialVerse: bookmark.verse
                                        )) {
                                            BookmarkItemView(
                                                bookmark: bookmark,
                                                isSelected: false,
                                                isEditing: false,
                                                onDelete: { deleteBookmark(bookmark) }
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, AppTheme.Dimensions.spacing)
                        }
                        
                        // Bottom action bar when editing
                        if editMode.isEditing && !selectedBookmarks.isEmpty {
                            HStack {
                                Spacer()
                                
                                Button(action: deleteSelectedBookmarks) {
                                    Label("Delete Selected", systemImage: "trash")
                                        .foregroundColor(AppTheme.Colors.error)
                                }
                                .padding()
                                .background(AppTheme.Colors.surface)
                                .cornerRadius(AppTheme.Dimensions.cornerRadius)
                                
                                Spacer()
                            }
                            .padding(.vertical, AppTheme.Dimensions.spacing)
                            .background(AppTheme.Colors.cardBackground)
                            .shadow(color: AppTheme.Shadows.subtle.color, radius: 3, x: 0, y: -1)
                            .transition(.move(edge: .bottom))
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !bookmarkManager.bookmarks.isEmpty {
                        EditButton()
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .onChange(of: editMode.isEditing) { oldValue, newValue in
                if !newValue {
                    // Clear selection when exiting edit mode
                    selectedBookmarks.removeAll()
                }
            }
        }
    }
    
    // MARK: - Bookmark Actions
    private func toggleSelection(_ bookmark: Bookmark) {
        if selectedBookmarks.contains(bookmark.id) {
            selectedBookmarks.remove(bookmark.id)
        } else {
            selectedBookmarks.insert(bookmark.id)
        }
    }
    
    private func deleteBookmark(_ bookmark: Bookmark) {
        bookmarkManager.removeBookmark(bookmark)
    }
    
    private func deleteSelectedBookmarks() {
        for bookmarkID in selectedBookmarks {
            if let bookmark = bookmarkManager.bookmarks.first(where: { $0.id == bookmarkID }) {
                bookmarkManager.removeBookmark(bookmark)
            }
        }
        selectedBookmarks.removeAll()
        if bookmarkManager.bookmarks.isEmpty {
            editMode = .inactive
        }
    }
}

#Preview {
    BookmarkView()
} 