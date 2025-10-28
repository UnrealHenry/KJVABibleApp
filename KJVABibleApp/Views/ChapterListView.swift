import SwiftUI

// Wrapper struct for chapter to make it identifiable
struct IdentifiableChapter: Identifiable {
    let id: Int
    let value: Int
    
    init(_ value: Int) {
        self.id = value
        self.value = value
    }
}

// MARK: - Chapter Grid Item View
struct ChapterGridItemView: View {
    let chapter: Int
    let bookName: String
    
    var body: some View {
        NavigationLink(destination: BibleTextView(bookName: bookName, chapter: chapter)) {
            Text("\(chapter)")
                .font(AppTheme.Typography.bodyBold)
                .foregroundColor(AppTheme.Colors.primaryText)
                .frame(width: 60, height: 60)
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.Dimensions.smallCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Dimensions.smallCornerRadius)
                        .stroke(AppTheme.Colors.divider, lineWidth: AppTheme.Dimensions.borderWidth)
                )
                .shadow(
                    color: AppTheme.Shadows.subtle.color,
                    radius: AppTheme.Shadows.subtle.radius,
                    x: AppTheme.Shadows.subtle.x,
                    y: AppTheme.Shadows.subtle.y
                )
        }
        .buttonStyle(AppTheme.chapterButtonStyle)
    }
}

// MARK: - Chapter Grid View
struct ChapterGridView: View {
    let bookName: String
    let chapterCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Dimensions.spacing) {
            // Info text
            Text("Select a chapter")
                .font(AppTheme.Typography.subheading)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .padding(.horizontal, AppTheme.Dimensions.spacing)
            
            // Chapters grid
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 70, maximum: 80), spacing: AppTheme.Dimensions.spacing)
            ], spacing: AppTheme.Dimensions.spacing) {
                ForEach(1...chapterCount, id: \.self) { chapter in
                    ChapterGridItemView(chapter: chapter, bookName: bookName)
                }
            }
            .padding(.horizontal, AppTheme.Dimensions.spacing)
        }
        .padding(.vertical, AppTheme.Dimensions.spacing)
    }
}

// MARK: - Header View
struct ChapterListHeaderView: View {
    let bookName: String
    
    var body: some View {
        VStack(spacing: AppTheme.Dimensions.smallSpacing) {
            // Book name
            Text(bookName)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.invertedText)
                .shadow(color: AppTheme.Shadows.text.color,
                        radius: AppTheme.Shadows.text.radius,
                        x: AppTheme.Shadows.text.x,
                        y: AppTheme.Shadows.text.y)
                .padding(.top, AppTheme.Dimensions.smallSpacing)
            
            // Decorative element
            HStack(spacing: AppTheme.Dimensions.spacing) {
                Spacer()
                DecorativeSymbol()
                Spacer()
            }
            .padding(.bottom, AppTheme.Dimensions.smallSpacing)
        }
        .padding(.vertical, AppTheme.Dimensions.spacing)
        .background(AppTheme.Gradients.primaryGradient)
    }
}

// MARK: - Main View
struct ChapterListView: View {
    let bookName: String
    @Environment(\.bibleDataManager) private var bibleDataManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ChapterListHeaderView(bookName: bookName)
                
                // Chapters
                ScrollView {
                    if let book = bibleDataManager.getBook(bookName) {
                        ChapterGridView(bookName: bookName, chapterCount: book.chapterCount)
                    } else {
                        // Error state
                        VStack(spacing: AppTheme.Dimensions.spacing) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: AppTheme.Dimensions.largeIconSize))
                                .foregroundColor(AppTheme.Colors.error)
                            
                            Text("Could not load chapters for \(bookName)")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .multilineTextAlignment(.center)
                                
                            Button("Return to Books") {
                                dismiss()
                            }
                            .buttonStyle(AppTheme.secondaryButtonStyle)
                        }
                        .padding(AppTheme.Dimensions.spacing * 2)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: AppTheme.Dimensions.tinySpacing) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Books")
                            .font(AppTheme.Typography.body)
                    }
                    .foregroundColor(AppTheme.Colors.invertedText)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ChapterListView(bookName: "Genesis")
            .environment(\.bibleDataManager, BibleDataManager.shared)
    }
} 