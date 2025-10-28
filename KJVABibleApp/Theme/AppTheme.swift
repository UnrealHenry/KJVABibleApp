import SwiftUI
import UIKit

struct AppTheme {
    // MARK: - Dynamic Color
    struct DynamicColor {
        let light: Color
        let dark: Color
        
        init(light: Color, dark: Color) {
            self.light = light
            self.dark = dark
        }
        
        var color: Color {
            Color(UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(self.dark)
                } else {
                    return UIColor(self.light)
                }
            })
        }
    }
    
    // MARK: - Colors
    struct Colors {
        // Primary palette
        static let primary = DynamicColor(
            light: Color(red: 0.55, green: 0.09, blue: 0.09),
            dark: Color(red: 0.70, green: 0.20, blue: 0.20)
        ).color
        
        static let themePrimary = Color("ThemePrimary")
        static let themeSecondary = Color("ThemeSecondary")
        static let themeAccent = Color("ThemeAccent")
        static let themeBackground = Color("ThemeBackground")
        
        static let secondary = DynamicColor(
            light: Color(red: 0.78, green: 0.62, blue: 0.30),
            dark: Color(red: 0.85, green: 0.70, blue: 0.25)
        ).color
        
        static let accent = DynamicColor(
            light: Color(red: 0.32, green: 0.07, blue: 0.07),
            dark: Color(red: 0.45, green: 0.15, blue: 0.15)
        ).color
        
        // Neutrals
        static let background = DynamicColor(
            light: Color(red: 0.98, green: 0.96, blue: 0.94),
            dark: Color(red: 0.08, green: 0.08, blue: 0.12)
        ).color
        
        static let surface = DynamicColor(
            light: Color(red: 0.97, green: 0.95, blue: 0.93),
            dark: Color(red: 0.10, green: 0.10, blue: 0.15)
        ).color
        
        static let cardBackground = DynamicColor(
            light: Color(red: 1.0, green: 0.99, blue: 0.97),
            dark: Color(red: 0.12, green: 0.12, blue: 0.17)
        ).color
        
        // Text
        static let primaryText = DynamicColor(
            light: Color(red: 0.10, green: 0.05, blue: 0.05),
            dark: Color(red: 1.0, green: 1.0, blue: 1.0)
        ).color
        
        static let secondaryText = DynamicColor(
            light: Color(red: 0.45, green: 0.15, blue: 0.15),
            dark: Color(red: 0.80, green: 0.64, blue: 0.64)
        ).color
        
        static let tertiaryText = DynamicColor(
            light: Color(red: 0.57, green: 0.42, blue: 0.42),
            dark: Color(red: 0.66, green: 0.53, blue: 0.53)
        ).color
        
        static let invertedText = DynamicColor(
            light: Color.white,
            dark: Color.black
        ).color
        
        // Semantic
        static let success = DynamicColor(
            light: Color(red: 0.20, green: 0.45, blue: 0.15),
            dark: Color(red: 0.30, green: 0.60, blue: 0.25)
        ).color
        
        static let error = DynamicColor(
            light: Color(red: 0.75, green: 0.15, blue: 0.15),
            dark: Color(red: 1.0, green: 0.25, blue: 0.25)
        ).color
        
        static let highlight = DynamicColor(
            light: Color(red: 0.95, green: 0.90, blue: 0.70),
            dark: Color(red: 0.40, green: 0.37, blue: 0.26)
        ).color
        
        // Special elements
        static let divider = DynamicColor(
            light: Color(red: 0.85, green: 0.75, blue: 0.75),
            dark: Color(red: 0.25, green: 0.21, blue: 0.21)
        ).color
        
        static let decorative = DynamicColor(
            light: Color(red: 0.82, green: 0.65, blue: 0.35),
            dark: Color(red: 1.0, green: 0.82, blue: 0.475)
        ).color
        
        static let chapterNumber = DynamicColor(
            light: Color(red: 0.63, green: 0.16, blue: 0.16),
            dark: Color(red: 0.88, green: 0.35, blue: 0.35)
        ).color
        
        static let verseNumber = DynamicColor(
            light: Color(red: 0.55, green: 0.35, blue: 0.20),
            dark: Color(red: 0.80, green: 0.51, blue: 0.29)
        ).color
        
        // Legacy support (keeping previous colors for backward compatibility)
        static let darkLeather = primary.opacity(0.9)
        static let burgundyLeather = accent
        static let gold = secondary
        static let brass = secondary.opacity(0.8)
        static let copper = secondary.opacity(0.7)
        static let parchment = surface
        static let cream = surface
        static let antiqueWhite = surface
        static let darkText = primaryText
        static let verseText = primaryText
        static let goldText = secondary
        static let copperText = secondary.opacity(0.7)
        static let text = primaryText
        static let embossedBorder = divider.opacity(0.8)
        static let borderColor = divider
        static let primaryColor = primary
        static let secondaryColor = secondary
        static let accentColor = accent
        static let backgroundColor = background
        static let textColor = primaryText
        static let verseNumberColor = verseNumber
        static let goldColor = secondary
    }
    
    // MARK: - Gradients
    struct Gradients {
        static let primaryGradient = LinearGradient(
            colors: [
                Colors.primary, 
                Colors.accent
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let accentGradient = LinearGradient(
            colors: [
                Colors.accent, 
                Colors.primary.opacity(0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let goldGradient = LinearGradient(
            colors: [
                Colors.secondary, 
                Colors.secondary.opacity(0.75)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let backgroundGradient = LinearGradient(
            colors: [
                Colors.background, 
                Colors.background.opacity(0.92)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let cardGradient = LinearGradient(
            colors: [
                Colors.cardBackground, 
                Colors.cardBackground.opacity(0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Legacy support
        static let leatherBackground = primaryGradient
        static let goldAccent = goldGradient
        static let parchmentBackground = backgroundGradient
        static let headerBackground = accentGradient
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let subtle = Shadow(
            color: Color.black.opacity(0.15),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let medium = Shadow(
            color: Color.black.opacity(0.20),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let strong = Shadow(
            color: Color.black.opacity(0.25),
            radius: 12,
            x: 0,
            y: 6
        )
        
        static let text = Shadow(
            color: Color.black.opacity(0.5),
            radius: 1,
            x: 0,
            y: 1
        )
        
        // Legacy support
        static let embossed = subtle
        static let engraved = Shadow(
            color: Color.black.opacity(0.15),
            radius: 2,
            x: -1,
            y: -1
        )
        static let floating = medium
    }
    
    // MARK: - Typography
    struct Typography {
        // Font families
        private static let titleFamily = "Baskerville"
        private static let bodyFamily = "Baskerville"
        
        // Font weights
        private static let regular = "Regular"
        private static let bold = "Bold"
        private static let semibold = "SemiBold"
        private static let italic = "Italic"
        
        // Font sizes
        static let displaySize: CGFloat = 36
        static let titleSize: CGFloat = 28
        static let headingSize: CGFloat = 22
        static let subheadingSize: CGFloat = 18
        static let bodySize: CGFloat = 16
        static let captionSize: CGFloat = 14
        static let smallSize: CGFloat = 12
        
        // Special sizes
        static let verseSize: CGFloat = 16
        static let verseNumberSize: CGFloat = 12
        static let chapterNumberSize: CGFloat = 48
        
        // Fonts
        static let display = Font.custom("\(titleFamily)-\(bold)", size: displaySize)
        static let title = Font.custom("\(titleFamily)-\(bold)", size: titleSize)
        static let heading = Font.custom("\(titleFamily)-\(semibold)", size: headingSize)
        static let subheading = Font.custom("\(titleFamily)-\(semibold)", size: subheadingSize)
        static let body = Font.custom("\(bodyFamily)-\(regular)", size: bodySize)
        static let bodyBold = Font.custom("\(bodyFamily)-\(bold)", size: bodySize)
        static let bodyItalic = Font.custom("\(bodyFamily)-\(italic)", size: bodySize)
        static let caption = Font.custom("\(bodyFamily)-\(italic)", size: captionSize)
        static let small = Font.custom("\(bodyFamily)-\(regular)", size: smallSize)
        
        // Special fonts
        static let verseFont = Font.custom("\(bodyFamily)-\(regular)", size: verseSize)
        static let verseNumberFont = Font.custom("\(bodyFamily)-\(italic)", size: verseNumberSize)
        static let chapterNumberFont = Font.custom("\(titleFamily)-\(bold)", size: chapterNumberSize)
        
        // Legacy support
        static let titleFont = title
        static let headingFont = heading
        static let bodyFont = body
        static let captionFont = caption
    }
    
    // MARK: - Dimensions
    struct Dimensions {
        // Spacing
        static let spacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let tinySpacing: CGFloat = 4
        static let largeSpacing: CGFloat = 24
        static let extraLargeSpacing: CGFloat = 32
        
        // Radii
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let largeCornerRadius: CGFloat = 16
        
        // Borders
        static let borderWidth: CGFloat = 1
        static let thickBorderWidth: CGFloat = 2
        
        // Component sizes
        static let buttonHeight: CGFloat = 48
        static let smallButtonHeight: CGFloat = 36
        static let iconSize: CGFloat = 24
        static let smallIconSize: CGFloat = 16
        static let largeIconSize: CGFloat = 32
        
        // Legacy support
        static let padding = spacing
        static let smallPadding = smallSpacing
        static let headerHeight: CGFloat = 120
        static let headerSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 20
        static let cardSpacing: CGFloat = 16
        static let tabHeight: CGFloat = 60
    }
    
    // MARK: - Custom View Modifiers
    struct ViewModifiers {
        struct CardStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .padding(Dimensions.spacing)
                    .background(Gradients.cardGradient)
                    .cornerRadius(Dimensions.cornerRadius)
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: Shadows.subtle.radius,
                        x: Shadows.subtle.x,
                        y: Shadows.subtle.y
                    )
            }
        }
        
        struct PrimaryButtonStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.invertedText)
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(Gradients.primaryGradient)
                    .cornerRadius(Dimensions.cornerRadius)
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: Shadows.subtle.radius,
                        x: Shadows.subtle.x,
                        y: Shadows.subtle.y
                    )
            }
        }
        
        struct GoldAccentButtonStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.primaryText)
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(Gradients.goldGradient)
                    .cornerRadius(Dimensions.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                            .stroke(Colors.secondary.opacity(0.3), lineWidth: Dimensions.borderWidth)
                    )
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: Shadows.subtle.radius,
                        x: Shadows.subtle.x,
                        y: Shadows.subtle.y
                    )
            }
        }
        
        struct SecondaryButtonStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.primary)
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(Colors.background)
                    .cornerRadius(Dimensions.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                            .stroke(Colors.primary, lineWidth: Dimensions.borderWidth)
                    )
            }
        }
        
        struct ChapterNumberStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(Typography.chapterNumberFont)
                    .foregroundColor(Colors.chapterNumber)
                    .shadow(
                        color: Shadows.text.color,
                        radius: Shadows.text.radius,
                        x: Shadows.text.x,
                        y: Shadows.text.y
                    )
            }
        }
        
        struct BookTitleStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(Typography.heading)
                    .foregroundColor(Colors.primaryText)
                    .padding(.vertical, Dimensions.smallSpacing)
            }
        }
        
        // Legacy support
        struct LeatherBackground: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(Gradients.primaryGradient)
            }
        }
        
        struct ParchmentBackground: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .background(Gradients.backgroundGradient)
                    .cornerRadius(Dimensions.cornerRadius)
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: Shadows.subtle.radius,
                        x: Shadows.subtle.x,
                        y: Shadows.subtle.y
                    )
            }
        }
        
        struct EngravedText: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .foregroundColor(Colors.secondary)
                    .shadow(
                        color: Shadows.text.color,
                        radius: Shadows.text.radius,
                        x: Shadows.text.x,
                        y: Shadows.text.y
                    )
            }
        }
        
        struct HeaderStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(Typography.titleFont)
                    .foregroundColor(Colors.invertedText)
                    .shadow(
                        color: Shadows.text.color,
                        radius: Shadows.text.radius,
                        x: Shadows.text.x,
                        y: Shadows.text.y
                    )
            }
        }
    }
    
    // MARK: - Custom Button Styles
    struct ButtonStyles {
        struct PrimaryButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.invertedText)
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(
                        Gradients.primaryGradient
                            .opacity(configuration.isPressed ? 0.9 : 1.0)
                    )
                    .cornerRadius(Dimensions.cornerRadius)
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: configuration.isPressed ? Shadows.subtle.radius / 2 : Shadows.subtle.radius,
                        x: 0,
                        y: configuration.isPressed ? 1 : 2
                    )
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
        
        struct GoldButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.primaryText)
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(
                        Gradients.goldGradient
                            .opacity(configuration.isPressed ? 0.9 : 1.0)
                    )
                    .cornerRadius(Dimensions.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                            .stroke(Colors.secondary.opacity(0.3), lineWidth: Dimensions.borderWidth)
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: configuration.isPressed ? Shadows.subtle.radius / 2 : Shadows.subtle.radius,
                        x: 0,
                        y: configuration.isPressed ? 1 : 2
                    )
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
        
        struct SecondaryButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .font(Typography.bodyBold)
                    .foregroundColor(Colors.primary)
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(
                        Colors.background
                            .opacity(configuration.isPressed ? 0.9 : 1.0)
                    )
                    .cornerRadius(Dimensions.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                            .stroke(Colors.primary, lineWidth: Dimensions.borderWidth)
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
        
        struct TertiaryButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .font(Typography.body)
                    .foregroundColor(Colors.primary)
                    .padding(.horizontal, Dimensions.smallSpacing)
                    .padding(.vertical, Dimensions.tinySpacing)
                    .background(
                        configuration.isPressed ?
                        Colors.primary.opacity(0.1) :
                        Color.clear
                    )
                    .cornerRadius(Dimensions.smallCornerRadius)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
        
        struct ChapterButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .padding(Dimensions.smallSpacing)
                    .background(
                        configuration.isPressed ?
                        Colors.highlight :
                        Colors.cardBackground
                    )
                    .cornerRadius(Dimensions.smallCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.smallCornerRadius)
                            .stroke(Colors.divider, lineWidth: Dimensions.borderWidth)
                    )
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: configuration.isPressed ? 1 : 2,
                        x: 0,
                        y: configuration.isPressed ? 1 : 2
                    )
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
        
        // Legacy support
        struct BibleButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .padding(.horizontal, Dimensions.spacing)
                    .padding(.vertical, Dimensions.smallSpacing)
                    .background(
                        Gradients.backgroundGradient
                            .opacity(configuration.isPressed ? 0.95 : 1.0)
                    )
                    .cornerRadius(Dimensions.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.cornerRadius)
                            .stroke(Colors.divider, lineWidth: Dimensions.borderWidth)
                    )
                    .shadow(
                        color: Shadows.subtle.color,
                        radius: configuration.isPressed ? 2 : 4,
                        x: 0,
                        y: configuration.isPressed ? 1 : 2
                    )
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            }
        }
    }
}

// MARK: - Convenience Extensions
extension View {
    func cardStyle() -> some View {
        modifier(AppTheme.ViewModifiers.CardStyle())
    }
    
    func primaryButtonStyle() -> some View {
        modifier(AppTheme.ViewModifiers.PrimaryButtonStyle())
    }
    
    func goldAccentButtonStyle() -> some View {
        modifier(AppTheme.ViewModifiers.GoldAccentButtonStyle())
    }
    
    func secondaryButtonStyle() -> some View {
        modifier(AppTheme.ViewModifiers.SecondaryButtonStyle())
    }
    
    func chapterNumberStyle() -> some View {
        modifier(AppTheme.ViewModifiers.ChapterNumberStyle())
    }
    
    func bookTitleStyle() -> some View {
        modifier(AppTheme.ViewModifiers.BookTitleStyle())
    }
    
    // Legacy support
    func leatherBackground() -> some View {
        modifier(AppTheme.ViewModifiers.LeatherBackground())
    }
    
    func parchmentBackground() -> some View {
        modifier(AppTheme.ViewModifiers.ParchmentBackground())
    }
    
    func engravedText() -> some View {
        modifier(AppTheme.ViewModifiers.EngravedText())
    }
}

// MARK: - Shadow Structure
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Text Modifiers
extension Text {
    func bookTitle() -> some View {
        self
            .font(AppTheme.Typography.heading)
            .foregroundColor(AppTheme.Colors.primaryText)
    }
    
    func decorativeText() -> some View {
        self
            .font(AppTheme.Typography.bodyItalic)
            .foregroundColor(AppTheme.Colors.secondary)
    }
    
    func verseText() -> some View {
        self
            .font(AppTheme.Typography.verseFont)
            .foregroundColor(AppTheme.Colors.primaryText)
            .lineSpacing(4)
    }
    
    func scriptureReference() -> some View {
        self
            .font(AppTheme.Typography.bodyBold)
            .foregroundColor(AppTheme.Colors.primary)
    }
}

// MARK: - Decorative Elements
struct DecorationLine: View {
    var body: some View {
        Rectangle()
            .fill(AppTheme.Colors.divider)
            .frame(height: 1)
            .padding(.horizontal, AppTheme.Dimensions.spacing)
    }
}

struct GoldOrnament: View {
    var body: some View {
        HStack(spacing: AppTheme.Dimensions.smallSpacing) {
            Rectangle()
                .fill(AppTheme.Colors.secondary)
                .frame(height: 1)
            
            Circle()
                .fill(AppTheme.Colors.secondary)
                .frame(width: 4, height: 4)
            
            Rectangle()
                .fill(AppTheme.Colors.secondary)
                .frame(height: 1)
        }
    }
}

struct DecorativeSymbol: View {
    var body: some View {
        Image(systemName: "cross.fill")
            .font(.system(size: AppTheme.Dimensions.smallIconSize))
            .foregroundColor(AppTheme.Colors.decorative)
    }
}

// MARK: - Convenience Extensions
extension AppTheme {
    static let primaryColor = Colors.primary
    static let secondaryColor = Colors.secondary
    static let accentColor = Colors.accent
    static let backgroundColor = Colors.background
    static let textColor = Colors.primaryText
    static let verseNumberColor = Colors.verseNumber
    static let goldColor = Colors.secondary // Single declaration of goldColor
    static let borderColor = Colors.divider
    
    static let textShadow = Shadows.text
    static let cardShadow = Shadows.subtle
    static let smallPadding = Dimensions.smallSpacing
    static let padding = Dimensions.spacing
    static let cornerRadius = Dimensions.cornerRadius
    
    static let backgroundGradient = Gradients.backgroundGradient
    static let cardGradient = Gradients.cardGradient
    
    static let titleFont = Typography.title
    static let headingFont = Typography.heading
    static let bodyFont = Typography.body
    static let verseFont = Typography.verseFont
    static let captionFont = Typography.caption
    
    static let primaryButtonStyle = ButtonStyles.PrimaryButtonStyle()
    static let secondaryButtonStyle = ButtonStyles.SecondaryButtonStyle() 
    static let tertiaryButtonStyle = ButtonStyles.TertiaryButtonStyle()
    static let chapterButtonStyle = ButtonStyles.ChapterButtonStyle()
    static let bibleButtonStyle = ButtonStyles.BibleButtonStyle()
    static let goldButtonStyle = ButtonStyles.GoldButtonStyle()
} 