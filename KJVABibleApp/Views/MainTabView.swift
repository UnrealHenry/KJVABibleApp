import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BibleHomeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Bible")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            BookmarkView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Bookmarks")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(AppTheme.accentColor)
        .onAppear {
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            
            // Vintage iOS 6 style
            appearance.backgroundColor = UIColor(AppTheme.primaryColor.opacity(0.95))
            
            // Tab bar item appearance
            let itemAppearance = UITabBarItemAppearance()
            
            // Normal state
            itemAppearance.normal.iconColor = UIColor(AppTheme.textColor.opacity(0.6))
            itemAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(AppTheme.textColor.opacity(0.6)),
                .font: UIFont(name: "Baskerville", size: 10) ?? .systemFont(ofSize: 10)
            ]
            
            // Selected state
            itemAppearance.selected.iconColor = UIColor(AppTheme.accentColor)
            itemAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(AppTheme.accentColor),
                .font: UIFont(name: "Baskerville-Bold", size: 10) ?? .boldSystemFont(ofSize: 10)
            ]
            
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.bibleDataManager, BibleDataManager.shared)
} 