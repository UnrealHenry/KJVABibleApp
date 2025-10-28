import SwiftUI

struct BibleHomeView: View {
    @Environment(\.bibleDataManager) private var bibleDataManager
    @State private var selectedSection = 0
    @State private var loadedBookCount = 0
    @State private var searchText = ""
    @State private var selectedTab = 0
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // MARK: - Book List Item View
    struct BookListItemView: View {
        let book: String
        
        var body: some View {
            HStack {
                Text(book)
                    .font(AppTheme.Typography.subheading)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .padding(.vertical, AppTheme.Dimensions.spacing)
            .contentShape(Rectangle())
        }
    }
    
    // MARK: - Search Bar View
    struct SearchBarView: View {
        @Binding var searchText: String
        
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Colors.secondary)
                
                TextField("Search scriptures...", text: $searchText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                }
            }
            .padding(AppTheme.Dimensions.smallSpacing)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.Dimensions.smallCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.smallCornerRadius)
                    .stroke(AppTheme.Colors.divider, lineWidth: AppTheme.Dimensions.borderWidth)
            )
            .padding(.horizontal, AppTheme.Dimensions.spacing)
            .padding(.vertical, AppTheme.Dimensions.smallSpacing)
        }
    }
    
    // MARK: - Header View
    struct HeaderView: View {
        var loadedBookCount: Int
        @Environment(\.bibleDataManager) private var bibleDataManager
        
        var body: some View {
            VStack(spacing: AppTheme.Dimensions.smallSpacing) {
                // App title
                VStack(spacing: 8) {
                    Text("THE HOLY BIBLE")
                        .font(AppTheme.Typography.subheading)
                        .foregroundColor(AppTheme.Colors.secondary)
                        .tracking(2)
                    
                    // Bible version title
                    if let manager = bibleDataManager as? BibleDataManager {
                        switch manager.currentVersion {
                        case .kjv:
                            Text("King James Version")
                                .font(AppTheme.Typography.display)
                                .foregroundColor(AppTheme.Colors.invertedText)
                                .shadow(
                                    color: AppTheme.Shadows.text.color,
                                    radius: AppTheme.Shadows.text.radius * 2,
                                    x: AppTheme.Shadows.text.x,
                                    y: AppTheme.Shadows.text.y * 2
                                )
                        case .reinaValera:
                            Text("Reina-Valera 1602")
                                .font(AppTheme.Typography.display)
                                .foregroundColor(AppTheme.Colors.invertedText)
                                .shadow(
                                    color: AppTheme.Shadows.text.color,
                                    radius: AppTheme.Shadows.text.radius * 2,
                                    x: AppTheme.Shadows.text.x,
                                    y: AppTheme.Shadows.text.y * 2
                                )
                        }
                    } else {
                        Text("King James Version")
                            .font(AppTheme.Typography.display)
                            .foregroundColor(AppTheme.Colors.invertedText)
                            .shadow(
                                color: AppTheme.Shadows.text.color,
                                radius: AppTheme.Shadows.text.radius * 2,
                                x: AppTheme.Shadows.text.x,
                                y: AppTheme.Shadows.text.y * 2
                            )
                    }
                    
                    GoldOrnament()
                        .frame(width: 180)
                        .padding(.top, 4)
                    
                    Text("\(loadedBookCount) books")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.secondary.opacity(0.8))
                        .padding(.top, 4)
                }
            }
            .padding(.top, 30)
            .padding(.bottom, AppTheme.Dimensions.spacing)
            .padding(.horizontal, AppTheme.Dimensions.spacing)
            .background(
                ZStack {
                    AppTheme.Gradients.primaryGradient
                        .edgesIgnoringSafeArea(.top)
                    
                    // Cross watermark
                    Image(systemName: "cross.fill")
                        .font(.system(size: 170))
                        .foregroundColor(AppTheme.Colors.accent.opacity(0.2))
                        .offset(x: 40, y: 0)
                }
            )
        }
    }
    
    // MARK: - Testament Tab View
    struct TestamentTabsView: View {
        @Binding var selectedSection: Int
        var namespace: Namespace.ID
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(["Old Testament", "New Testament", "Apocrypha"].indices, id: \.self) { index in
                    let title = ["Old Testament", "New Testament", "Apocrypha"][index]
                    
                    Button(action: {
                        selectedSection = index
                    }) {
                        VStack(spacing: 4) {
                            Text(title)
                                .font(selectedSection == index ? 
                                      AppTheme.Typography.bodyBold : 
                                      AppTheme.Typography.body)
                                .foregroundColor(selectedSection == index ? 
                                               AppTheme.Colors.primary : 
                                               AppTheme.Colors.secondaryText)
                            
                            if selectedSection == index {
                                Rectangle()
                                    .fill(AppTheme.Colors.secondary)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "tab_indicator", in: namespace)
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppTheme.Dimensions.spacing)
            .padding(.vertical, AppTheme.Dimensions.smallSpacing)
            .background(AppTheme.Colors.cardBackground)
            .shadow(
                color: AppTheme.Shadows.subtle.color,
                radius: 2,
                x: 0,
                y: 2
            )
        }
    }
    
    @Namespace private var namespace
    
    // MARK: - Bible Content View
    private var bibleContentView: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HeaderView(loadedBookCount: loadedBookCount)
                    
                    // Search bar
                    SearchBarView(searchText: $searchText)
                    
                    // Section selector tabs
                    TestamentTabsView(selectedSection: $selectedSection, namespace: namespace)
                    
                    // List of books
                    ScrollView {
                        VStack(spacing: AppTheme.Dimensions.smallSpacing) {
                            let books = selectedSection == 0 
                                ? bibleDataManager.oldTestamentBooks 
                                : (selectedSection == 1 
                                    ? bibleDataManager.newTestamentBooks 
                                    : bibleDataManager.apocryphaBooks)
                            
                            // Section title with count
                            HStack {
                                Text(selectedSection == 0 
                                    ? "Old Testament" 
                                    : (selectedSection == 1 
                                        ? "New Testament" 
                                        : "Apocrypha"))
                                    .font(AppTheme.Typography.heading)
                                    .foregroundColor(AppTheme.Colors.primary)
                                
                                Spacer()
                                
                                Text("\(books.count) books")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                            .padding(.horizontal, AppTheme.Dimensions.spacing)
                            .padding(.top, AppTheme.Dimensions.spacing)
                            
                            // Books list card
                            VStack(spacing: 0) {
                                ForEach(books, id: \.self) { book in
                                    NavigationLink(destination: ChapterListView(bookName: book)) {
                                        BookListItemView(book: book)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if book != books.last {
                                        Divider()
                                            .background(AppTheme.Colors.divider)
                                            .padding(.horizontal, 4)
                                    }
                                }
                            }
                            .padding(.horizontal, AppTheme.Dimensions.spacing)
                            .background(AppTheme.Colors.cardBackground)
                            .cornerRadius(AppTheme.Dimensions.cornerRadius)
                            .shadow(
                                color: AppTheme.Shadows.subtle.color,
                                radius: AppTheme.Shadows.subtle.radius,
                                x: AppTheme.Shadows.subtle.x,
                                y: AppTheme.Shadows.subtle.y
                            )
                            .padding(.horizontal, AppTheme.Dimensions.spacing)
                            
                            // Scripture quote based on the current Bible version
                            if selectedSection == 1 { // Show only for New Testament
                                VStack(spacing: AppTheme.Dimensions.smallSpacing) {
                                    if let manager = bibleDataManager as? BibleDataManager, manager.currentVersion == .reinaValera {
                                        Text("\"Porque de tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna.\"")
                                            .font(AppTheme.Typography.bodyItalic)
                                            .foregroundColor(AppTheme.Colors.primary)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 4)
                                        
                                        Text("Juan 3:16")
                                            .font(AppTheme.Typography.caption)
                                            .foregroundColor(AppTheme.Colors.secondary)
                                    } else {
                                        Text("\"For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.\"")
                                            .font(AppTheme.Typography.bodyItalic)
                                            .foregroundColor(AppTheme.Colors.primary)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 4)
                                        
                                        Text("John 3:16")
                                            .font(AppTheme.Typography.caption)
                                            .foregroundColor(AppTheme.Colors.secondary)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AppTheme.Colors.surface)
                                .cornerRadius(AppTheme.Dimensions.cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                                        .stroke(AppTheme.Colors.divider, lineWidth: AppTheme.Dimensions.borderWidth)
                                )
                                .padding(.horizontal, AppTheme.Dimensions.spacing)
                                .padding(.top, AppTheme.Dimensions.spacing)
                            }
                            
                            // Footer info
                            VStack(spacing: AppTheme.Dimensions.tinySpacing) {
                                if selectedSection == 0 {
                                    Text("The First Covenant")
                                } else if selectedSection == 1 {
                                    Text("The New Covenant of Our Lord Jesus Christ")
                                } else {
                                    Text("Additional Sacred Texts")
                                }
                                
                                // Show current Bible version
                                if let manager = bibleDataManager as? BibleDataManager {
                                    Text(manager.currentVersion.displayName)
                                        .font(AppTheme.Typography.caption)
                                        .foregroundColor(AppTheme.Colors.tertiaryText)
                                } else {
                                    Text("King James Version (1611)")
                                        .font(AppTheme.Typography.caption)
                                        .foregroundColor(AppTheme.Colors.tertiaryText)
                                }
                            }
                            .font(AppTheme.Typography.small)
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                            .padding(.vertical, AppTheme.Dimensions.spacing)
                        }
                        .padding(.bottom, AppTheme.Dimensions.spacing)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Main View
    var body: some View {
        ZStack {
            // Background color extends behind the safe area
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            // Main tab view
            TabView(selection: $selectedTab) {
                // Bible Home View
                bibleContentView
                    .tabItem {
                        Label("Bible", systemImage: "book.fill")
                    }
                    .tag(0)
                
                // Search View
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                // Bookmarks View
                BookmarkView()
                    .tabItem {
                        Label("Bookmark", systemImage: "bookmark.fill")
                    }
                    .tag(2)
                
                // Settings View
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(3)
            }
            .accentColor(AppTheme.Colors.primary)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            // Update the loaded book count
            loadedBookCount = bibleDataManager.getAllBooks().count
            
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(AppTheme.Colors.cardBackground)
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

#Preview {
    BibleHomeView()
        .environment(\.bibleDataManager, BibleDataManager.shared)
} 