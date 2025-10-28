import SwiftUI

struct SettingsView: View {
    @AppStorage("fontSize") private var fontSize: Double = 18
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("showVerseNumbers") private var showVerseNumbers = true
    @AppStorage("showChapterNumbers") private var showChapterNumbers = true
    @AppStorage("useModernEnglish") private var useModernEnglish = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.bibleDataManager) private var bibleDataManager
    @State private var showLanguageInfoAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Vintage paper texture background
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.padding) {
                        // Header
                        VStack(spacing: AppTheme.smallPadding/2) {
                            Text("SETTINGS")
                                .font(AppTheme.titleFont)
                                .foregroundColor(AppTheme.primaryColor)
                                .tracking(2)
                                .shadow(
                                    color: AppTheme.textShadow.color,
                                    radius: AppTheme.textShadow.radius,
                                    x: AppTheme.textShadow.x,
                                    y: AppTheme.textShadow.y
                                )
                            
                            DecorationLine()
                                .padding(.vertical, 4)
                        }
                        .padding(.top, AppTheme.padding)
                        
                        // Settings groups
                        VStack(spacing: AppTheme.padding) {
                            // Version Selection
                            if let manager = bibleDataManager as? BibleDataManager {
                                settingsGroup(title: "Bible Version") {
                                    VStack(alignment: .leading, spacing: 12) {
                                        ForEach(BibleVersion.allCases, id: \.self) { version in
                                            Button(action: {
                                                if version != manager.currentVersion {
                                                    manager.switchVersion(to: version)
                                                    
                                                    // Only show info alert when switching to Spanish version
                                                    if version == .reinaValera {
                                                        showLanguageInfoAlert = true
                                                    }
                                                }
                                            }) {
                                                HStack {
                                                    Text(version.displayName)
                                                        .font(AppTheme.bodyFont)
                                                        .foregroundColor(AppTheme.primaryColor)
                                                    
                                                    Spacer()
                                                    
                                                    if version == manager.currentVersion {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(AppTheme.accentColor)
                                                    }
                                                }
                                                .padding()
                                                .background(
                                                    version == manager.currentVersion ?
                                                    AppTheme.cardGradient.opacity(0.8) :
                                                    AppTheme.cardGradient.opacity(0.5)
                                                )
                                                .cornerRadius(AppTheme.cornerRadius)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                                        .stroke(
                                                            version == manager.currentVersion ?
                                                            AppTheme.accentColor.opacity(0.5) :
                                                            Color.clear,
                                                            lineWidth: 1
                                                        )
                                                )
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(AppTheme.cardGradient)
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .shadow(
                                        color: AppTheme.cardShadow.color,
                                        radius: AppTheme.cardShadow.radius,
                                        x: AppTheme.cardShadow.x,
                                        y: AppTheme.cardShadow.y
                                    )
                                }
                            }
                            
                            // Display Settings
                            settingsGroup(title: "Display") {
                                // Font Size
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Font Size")
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.primaryColor)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(fontSize))")
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.accentColor)
                                    }
                                    
                                    Slider(value: $fontSize, in: 14...24, step: 1)
                                        .accentColor(AppTheme.accentColor)
                                }
                                .padding()
                                .background(AppTheme.cardGradient)
                                .cornerRadius(AppTheme.cornerRadius)
                                .shadow(
                                    color: AppTheme.cardShadow.color,
                                    radius: AppTheme.cardShadow.radius,
                                    x: AppTheme.cardShadow.x,
                                    y: AppTheme.cardShadow.y
                                )
                                
                                // Dark Mode
                                Toggle(isOn: $isDarkMode) {
                                    Text("Dark Mode")
                                        .font(AppTheme.bodyFont)
                                        .foregroundColor(AppTheme.primaryColor)
                                }
                                .onChange(of: isDarkMode) { oldValue, newValue in
                                    setAppearanceMode(darkMode: newValue)
                                }
                                .padding()
                                .background(AppTheme.cardGradient)
                                .cornerRadius(AppTheme.cornerRadius)
                                .shadow(
                                    color: AppTheme.cardShadow.color,
                                    radius: AppTheme.cardShadow.radius,
                                    x: AppTheme.cardShadow.x,
                                    y: AppTheme.cardShadow.y
                                )
                            }
                            
                            // Reading Settings
                            settingsGroup(title: "Reading") {
                                // Modern English Toggle (only show for KJV)
                                if let manager = bibleDataManager as? BibleDataManager, manager.currentVersion == .kjv {
                                    Toggle(isOn: $useModernEnglish) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Use Modern English")
                                                .font(AppTheme.bodyFont)
                                                .foregroundColor(AppTheme.primaryColor)
                                            
                                            Text(useModernEnglish ? 
                                                "Updated spelling and language for easier reading" : 
                                                "Original King James Version (1611) with archaic spellings")
                                                .font(AppTheme.Typography.caption)
                                                .foregroundColor(AppTheme.Colors.secondaryText)
                                        }
                                    }
                                    .onChange(of: useModernEnglish) { oldValue, newValue in
                                        // Update BibleDataManager
                                        if manager.useModernEnglish != newValue {
                                            manager.toggleModernEnglish()
                                        }
                                        
                                        // Also store in UserDefaults
                                        UserDefaults.standard.set(newValue, forKey: "useModernEnglish")
                                    }
                                    .padding()
                                    .background(AppTheme.cardGradient)
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .shadow(
                                        color: AppTheme.cardShadow.color,
                                        radius: AppTheme.cardShadow.radius,
                                        x: AppTheme.cardShadow.x,
                                        y: AppTheme.cardShadow.y
                                    )
                                    
                                    // Example text to show difference
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Example:")
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.primaryColor)
                                        
                                        Text(useModernEnglish ? 
                                             "For God so loved the world, that he gave his only begotten Son, that whoever believes in him should not perish, but have everlasting life." : 
                                             "For God so loued the world, that hee gaue his onely begotten Sonne, that whosoeuer beleeueth in him should not perish, but haue euerlasting life.")
                                            .font(AppTheme.bodyFont)
                                            .italic()
                                            .foregroundColor(AppTheme.Colors.primary)
                                            .padding(.vertical, 4)
                                        
                                        Text("John 3:16")
                                            .font(AppTheme.captionFont)
                                            .foregroundColor(AppTheme.Colors.tertiaryText)
                                    }
                                    .padding()
                                    .background(AppTheme.cardGradient)
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .shadow(
                                        color: AppTheme.cardShadow.color,
                                        radius: AppTheme.cardShadow.radius,
                                        x: AppTheme.cardShadow.x,
                                        y: AppTheme.cardShadow.y
                                    )
                                }
                                
                                // Verse Numbers
                                Toggle(isOn: $showVerseNumbers) {
                                    Text("Show Verse Numbers")
                                        .font(AppTheme.bodyFont)
                                        .foregroundColor(AppTheme.primaryColor)
                                }
                                .padding()
                                .background(AppTheme.cardGradient)
                                .cornerRadius(AppTheme.cornerRadius)
                                .shadow(
                                    color: AppTheme.cardShadow.color,
                                    radius: AppTheme.cardShadow.radius,
                                    x: AppTheme.cardShadow.x,
                                    y: AppTheme.cardShadow.y
                                )
                                
                                // Chapter Numbers
                                Toggle(isOn: $showChapterNumbers) {
                                    Text("Show Chapter Numbers")
                                        .font(AppTheme.bodyFont)
                                        .foregroundColor(AppTheme.primaryColor)
                                }
                                .padding()
                                .background(AppTheme.cardGradient)
                                .cornerRadius(AppTheme.cornerRadius)
                                .shadow(
                                    color: AppTheme.cardShadow.color,
                                    radius: AppTheme.cardShadow.radius,
                                    x: AppTheme.cardShadow.x,
                                    y: AppTheme.cardShadow.y
                                )
                            }
                            
                            // About
                            settingsGroup(title: "About") {
                                VStack(spacing: AppTheme.smallPadding) {
                                    if let manager = bibleDataManager as? BibleDataManager {
                                        Text(manager.currentVersion == .kjv ? "King James Version" : "Reina-Valera 1602")
                                            .font(AppTheme.headingFont)
                                            .foregroundColor(AppTheme.primaryColor)
                                    } else {
                                        Text("Bible App")
                                            .font(AppTheme.headingFont)
                                            .foregroundColor(AppTheme.primaryColor)
                                    }
                                    
                                    Text("Version 1.0")
                                        .font(AppTheme.captionFont)
                                        .foregroundColor(AppTheme.textColor.opacity(0.6))
                                    
                                    Text("© 2024 Your Name")
                                        .font(AppTheme.captionFont)
                                        .foregroundColor(AppTheme.textColor.opacity(0.6))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AppTheme.cardGradient)
                                .cornerRadius(AppTheme.cornerRadius)
                                .shadow(
                                    color: AppTheme.cardShadow.color,
                                    radius: AppTheme.cardShadow.radius,
                                    x: AppTheme.cardShadow.x,
                                    y: AppTheme.cardShadow.y
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Sync the toggle with the current system appearance
                isDarkMode = colorScheme == .dark
            }
            .alert("Spanish Bible", isPresented: $showLanguageInfoAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You've switched to the Reina-Valera 1602 Spanish Bible with complete Old and New Testament plus Apocrypha.")
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    // Function to set the system appearance mode
    private func setAppearanceMode(darkMode: Bool) {
        // The preferredColorScheme modifier will handle this
        // based on the isDarkMode binding
    }
    
    private func settingsGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
            Text(title)
                .font(AppTheme.headingFont)
                .foregroundColor(AppTheme.primaryColor)
                .padding(.horizontal)
            
            content()
        }
    }
}

#Preview {
    SettingsView()
} 