import Foundation
import SwiftUI

// New structure to match the JSON format of the Bible book files
struct BibleBookJSON: Codable {
    let book: String
    let chapterCount: String
    let chapters: [Chapter]
    
    enum CodingKeys: String, CodingKey {
        case book
        case chapterCount = "chapter-count"
        case chapters
    }
    
    struct Chapter: Codable {
        let chapter: Int
        let verses: [Verse]
    }
    
    struct Verse: Codable {
        let verse: Int
        let text: String
    }
}

// Original BibleBook struct used by the app
struct BibleBook: Identifiable, Codable {
    let id: String
    let name: String
    let chapters: [Int: [String: String]]
    
    var chapterCount: Int {
        return chapters.count
    }
}

struct BibleData: Codable {
    let books: [String]
    let bookData: [String: BibleBook]
}

// Enum for Bible versions
enum BibleVersion: String, CaseIterable, Codable {
    case kjv = "KJV-1611"
    case reinaValera = "RV-1602"
    
    var displayName: String {
        switch self {
        case .kjv:
            return "King James Version (1611)"
        case .reinaValera:
            return "Reina-Valera (1602)"
        }
    }
    
    var directoryName: String {
        switch self {
        case .kjv:
            return "Bible-kjv-1611-main"
        case .reinaValera:
            return "Bible-rv-1602-main"
        }
    }
    
    var booksFileName: String {
        switch self {
        case .kjv:
            return "KJV-Books.json"
        case .reinaValera:
            return "RV-Books.json"
        }
    }
    
    var language: BibleLanguage {
        switch self {
        case .kjv:
            return .english
        case .reinaValera:
            return .spanish
        }
    }
}

// Enum for Bible languages
enum BibleLanguage: String, Codable {
    case english
    case spanish
}

// MARK: - Bible Data Manager Protocol
protocol BibleDataManaging {
    func getBook(_ name: String) -> BibleBook?
    func getVerse(book: String, chapter: Int, verse: Int) -> String?
    func getAllBooks() -> [String]
    func getOldTestamentBooks() -> [String]
    func getNewTestamentBooks() -> [String]
    func getApocryphaBooks() -> [String]
    func isApocryphaBook(_ book: String) -> Bool
    func debugPrintBookStatus()
    func getChapterCount(book: String) -> Int
    func getVerseCount(book: String, chapter: Int) -> Int
    var oldTestamentBooks: [String] { get }
    var newTestamentBooks: [String] { get }
    var apocryphaBooks: [String] { get }
    var currentVersion: BibleVersion { get }
    func switchVersion(to version: BibleVersion)
}

// MARK: - Bible Text Modernizer
class BibleTextModernizer {
    static let shared = BibleTextModernizer()
    
    // Common KJV archaic words and their modern equivalents
    private let archaicWordsMap: [String: String] = [
        "thee": "you",
        "thou": "you",
        "thy": "your",
        "thine": "your",
        "ye": "you",
        "hast": "have",
        "hath": "has",
        "dost": "do",
        "doth": "does",
        "didst": "did",
        "shalt": "shall",
        "wilt": "will",
        "art": "are",
        "cometh": "comes",
        "goeth": "goes",
        "knoweth": "knows",
        "seeketh": "seeks",
        "findeth": "finds",
        "giveth": "gives",
        "taketh": "takes",
        "maketh": "makes",
        "speaketh": "speaks",
        "heareth": "hears",
        "seeth": "sees",
        "walketh": "walks",
        "doeth": "does",
        "saith": "says",
        "whither": "where",
        "thither": "there",
        "hither": "here",
        "behold": "look",
        "wherefore": "therefore",
        "verily": "truly",
        "unto": "to",
        "mine": "my",
        "spake": "spoke",
        "begat": "fathered",
        "brethren": "brothers",
        "amongst": "among",
        "whilst": "while"
    ]
    
    // Archaic spelling patterns and their modern replacements
    private let archaicSpellingPatterns: [(pattern: String, replacement: String)] = [
        // Vowel replacements
        ("heauen", "heaven"),
        ("euen", "even"),
        ("seuen", "seven"),
        ("ouer", "over"),
        ("euery", "every"),
        ("euil", "evil"),
        ("deuil", "devil"),
        ("Iesu", "Jesu"),
        ("Iesus", "Jesus"),
        ("iust", "just"),
        ("iudge", "judge"),
        ("iudgment", "judgment"),
        ("ioy", "joy"),
        ("iourney", "journey"),
        ("loue", "love"),
        ("liue", "live"),
        ("saue", "save"),
        ("haue", "have"),
        ("giue", "give"),
        ("receiue", "receive"),
        ("beleeue", "believe"),
        ("leaue", "leave"),
        ("vp", "up"),
        ("vs", "us"),
        ("vnto", "unto"),
        ("vpon", "upon"),
        ("vnder", "under"),
        ("iust", "just"),
        
        // Other common archaic spellings
        ("sonne", "son"),
        ("sunne", "sun"),
        ("citie", "city"),
        ("dayes", "days"),
        ("doore", "door"),
        ("hee", "he"),
        ("shee", "she"),
        ("wee", "we"),
        ("thinke", "think"),
        ("sinne", "sin"),
        ("shippe", "ship"),
        ("spirite", "spirit"),
        ("lorde", "lord"),
        ("soule", "soul"),
        ("onely", "only"),
        ("assoone", "as soon"),
        ("betweene", "between"),
        ("seruant", "servant"),
        ("seruice", "service"),
        ("yeeres", "years"),
        ("owne", "own"),
        ("Ioseph", "Joseph"),
        ("Iacob", "Jacob"),
        ("Ierusalem", "Jerusalem"),
        ("Iohn", "John"),
        ("Iordan", "Jordan"),
        ("Iudea", "Judea"),
        ("Iudah", "Judah")
    ]
    
    // Transform text from KJV English to modern English
    func modernize(_ text: String) -> String {
        var modernText = text
        
        // First, update archaic spellings and vowel patterns
        for (pattern, replacement) in archaicSpellingPatterns {
            let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            if let regex = regex {
                let range = NSRange(location: 0, length: modernText.utf16.count)
                let matches = regex.matches(in: modernText, options: [], range: range)
                
                for match in matches.reversed() {
                    let matchedString = (modernText as NSString).substring(with: match.range)
                    var replacementString = replacement
                    
                    // Preserve capitalization
                    if let firstChar = matchedString.first, firstChar.isUppercase {
                        replacementString = replacement.prefix(1).uppercased() + replacement.dropFirst()
                    }
                    
                    modernText = (modernText as NSString).replacingCharacters(in: match.range, with: replacementString)
                }
            }
        }
        
        // Then, update archaic words
        for (archaic, modern) in archaicWordsMap {
            // Create regex patterns that match word boundaries
            let pattern = "\\b\(archaic)\\b"
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                // Get the range of the entire text
                let range = NSRange(location: 0, length: modernText.utf16.count)
                
                // Find all matches
                let matches = regex.matches(in: modernText, options: [], range: range)
                
                // Process matches in reverse order to avoid changing the ranges of subsequent matches
                for match in matches.reversed() {
                    // Get the matched word
                    let matchedWord = (modernText as NSString).substring(with: match.range)
                    
                    // Determine replacement based on case
                    var replacement = modern
                    if let firstChar = matchedWord.first, firstChar.isUppercase {
                        replacement = modern.prefix(1).uppercased() + modern.dropFirst()
                    }
                    
                    // Replace this specific occurrence
                    modernText = (modernText as NSString).replacingCharacters(in: match.range, with: replacement)
                }
            }
        }
        
        // Special case for common letter substitutions ('u' for 'v' and vice versa in certain positions)
        modernText = modernText.replacingOccurrences(of: "v([aeiou])", with: "v$1", options: [.regularExpression, .caseInsensitive])
        modernText = modernText.replacingOccurrences(of: "u([bcdfghjklmnpqrstvwxyz])", with: "u$1", options: [.regularExpression, .caseInsensitive])
        
        return modernText
    }
    
    // Process text based on user preference
    func processText(_ text: String, useModernEnglish: Bool) -> String {
        if useModernEnglish {
            return modernize(text)
        }
        return text
    }
}

// MARK: - Bible Data Manager
class BibleDataManager: ObservableObject, BibleDataManaging {
    static let shared = BibleDataManager()
    
    @Published private(set) var books: [String: BibleBook] = [:]
    @Published private(set) var isLoading = false
    @Published private(set) var hasLoaded = false
    @Published private(set) var error: Error?
    @Published private var bibleDatas: [BibleVersion: BibleData] = [:]
    @Published var useModernEnglish: Bool = UserDefaults.standard.bool(forKey: "useModernEnglish")
    @Published var currentVersion: BibleVersion = UserDefaults.standard.string(forKey: "selectedBibleVersion").flatMap { BibleVersion(rawValue: $0) } ?? .kjv
    
    // Cache for file paths
    private var booksJsonPathCache: [BibleVersion: URL] = [:]
    private var bibleDirectoryCache: [BibleVersion: URL] = [:]
    
    // Loading synchronization
    private let loadingQueue = DispatchQueue(label: "com.bible.loadingQueue")
    private var isCurrentlyLoading = false
    
    // Predefined books lists as fallback
    private let englishOldTestamentBooksList = [
        "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", 
        "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", 
        "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles",
        "Ezra", "Nehemiah", "Esther", "Job", "Psalms", 
        "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", 
        "Jeremiah", "Lamentations", "Ezekiel", "Daniel", 
        "Hosea", "Joel", "Amos", "Obadiah", "Jonah", 
        "Micah", "Nahum", "Habakkuk", "Zephaniah", 
        "Haggai", "Zechariah", "Malachi"
    ]
    
    private let englishNewTestamentBooksList = [
        "Matthew", "Mark", "Luke", "John", "Acts", 
        "Romans", "1 Corinthians", "2 Corinthians", "Galatians", 
        "Ephesians", "Philippians", "Colossians", 
        "1 Thessalonians", "2 Thessalonians", "1 Timothy", 
        "2 Timothy", "Titus", "Philemon", "Hebrews", 
        "James", "1 Peter", "2 Peter", "1 John", 
        "2 John", "3 John", "Jude", "Revelation"
    ]
    
    private let englishApocryphaBooksList = [
        "1 Esdras", "2 Esdras", "Tobit", "Judith", 
        "Wisdom of Solomon", "Ecclesiasticus", "Baruch", 
        "Letter of Jeremiah", "Prayer of Azariah", "Susanna", 
        "Bel and the Dragon", "Prayer of Manasseh", 
        "1 Maccabees", "2 Maccabees"
    ]
    
    private let spanishOldTestamentBooksList = [
        "Génesis", "Éxodo", "Levítico", "Números", "Deuteronomio", 
        "Josué", "Jueces", "Rut", "1 Samuel", "2 Samuel", 
        "1 Reyes", "2 Reyes", "1 Crónicas", "2 Crónicas",
        "Esdras", "Nehemías", "Ester", "Job", "Salmos", 
        "Proverbios", "Eclesiastés", "Cantar de los Cantares", "Isaías", 
        "Jeremías", "Lamentaciones", "Ezequiel", "Daniel", 
        "Oseas", "Joel", "Amós", "Abdías", "Jonás", 
        "Miqueas", "Nahum", "Habacuc", "Sofonías", 
        "Hageo", "Zacarías", "Malaquías"
    ]
    
    private let spanishNewTestamentBooksList = [
        "Mateo", "Marcos", "Lucas", "Juan", "Hechos", 
        "Romanos", "1 Corintios", "2 Corintios", "Gálatas", 
        "Efesios", "Filipenses", "Colosenses", 
        "1 Tesalonicenses", "2 Tesalonicenses", "1 Timoteo", 
        "2 Timoteo", "Tito", "Filemón", "Hebreos", 
        "Santiago", "1 Pedro", "2 Pedro", "1 Juan", 
        "2 Juan", "3 Juan", "Judas", "Apocalipsis"
    ]
    
    private let spanishApocryphaBooksList = [
        "1 Esdras", "2 Esdras", "Tobías", "Judit", 
        "Sabiduría", "Eclesiástico", "Baruc", 
        "Carta de Jeremías", "Oración de Azarías", "Susana", 
        "Bel y el Dragón", "Oración de Manasés", 
        "1 Macabeos", "2 Macabeos"
    ]
    
    var oldTestamentBooks: [String] { 
        switch currentVersion.language {
        case .english:
            return englishOldTestamentBooksList
        case .spanish:
            return spanishOldTestamentBooksList
        }
    }
    
    var newTestamentBooks: [String] { 
        switch currentVersion.language {
        case .english:
            return englishNewTestamentBooksList
        case .spanish:
            return spanishNewTestamentBooksList
        }
    }
    
    var apocryphaBooks: [String] { 
        switch currentVersion.language {
        case .english:
            return englishApocryphaBooksList
        case .spanish:
            return spanishApocryphaBooksList
        }
    }
    
    // Bible text modernizer
    private let textModernizer = BibleTextModernizer.shared
    
    private init() {
        // Load data in background
        loadBibleDataIfNeeded(for: currentVersion)
    }
    
    private func loadBibleDataIfNeeded(for version: BibleVersion) {
        loadingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Check if already loaded or currently loading
            if self.bibleDatas[version] != nil || self.isCurrentlyLoading {
                return
            }
            
            // Set loading state
            self.isCurrentlyLoading = true
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            // Start actual loading process
            self.performBibleDataLoading(for: version)
        }
    }
    
    private func performBibleDataLoading(for version: BibleVersion) {
        print("Starting to load Bible data for \(version.displayName)...")
        
        // Key for caching
        let cacheKey = "cachedBibleData-\(version.rawValue)"
        
        // Try to load from cache first
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
           let decodedData = try? JSONDecoder().decode(BibleData.self, from: cachedData) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.bibleDatas[version] = decodedData
                if version == self.currentVersion {
                    self.books = decodedData.bookData
                }
                self.isLoading = false
                self.hasLoaded = true
                print("Loaded Bible data from cache for \(version.displayName)")
            }
            
            self.isCurrentlyLoading = false
            return
        }
        
        // If no cache, try loading from file
        if let booksJsonURL = findBooksJsonPath(for: version) {
            let bibleDirectory = booksJsonURL.deletingLastPathComponent()
            if loadBooksDirectly(from: bibleDirectory, for: version) {
                // Cache the loaded data
                if let data = try? JSONEncoder().encode(self.bibleDatas[version]) {
                    UserDefaults.standard.set(data, forKey: cacheKey)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.hasLoaded = true
                }
                
                self.isCurrentlyLoading = false
                return
            }
        }
        
        // If all else fails, create fallback
        createFallbackBibleData(for: version)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.hasLoaded = true
        }
        
        self.isCurrentlyLoading = false
    }
    
    private func findBooksJsonPath(for version: BibleVersion) -> URL? {
        // Check cache first
        if let cachedPath = booksJsonPathCache[version] {
            return cachedPath
        }
        
        let fileManager = FileManager.default
        
        // Check app bundle first
        if let bundlePath = findBooksJsonInBundle(for: version) {
            booksJsonPathCache[version] = bundlePath
            return bundlePath
        }
        
        // Check documents directory
        if let documentsPath = findBooksJsonInDocuments(for: version) {
            booksJsonPathCache[version] = documentsPath
            return documentsPath
        }
        
        // Check for development paths
        if let projectPath = findProjectBiblePath(for: version) {
            let booksJsonPath = projectPath.appendingPathComponent("Books.json")
            booksJsonPathCache[version] = booksJsonPath
            return booksJsonPath
        }
        
        print("Could not find Books.json for \(version.displayName) in any location")
        return nil
    }
    
    private func findBooksJsonInBundle(for version: BibleVersion) -> URL? {
        // Try with version-specific filename first
        if let bundlePath = Bundle.main.path(forResource: version.booksFileName.replacingOccurrences(of: ".json", with: ""), ofType: "json", inDirectory: "Resources/\(version.directoryName)") {
            print("Found \(version.booksFileName) in bundle for \(version.displayName)")
            return URL(fileURLWithPath: bundlePath)
        }
        
        // Then try with standard Books.json name as fallback
        if let bundlePath = Bundle.main.path(forResource: "Books", ofType: "json", inDirectory: "Resources/\(version.directoryName)") {
            print("Found Books.json in bundle for \(version.displayName)")
            return URL(fileURLWithPath: bundlePath)
        }
        
        // Try alternate paths
        if let bundlePath = Bundle.main.path(forResource: version.booksFileName.replacingOccurrences(of: ".json", with: ""), ofType: "json", inDirectory: version.directoryName) {
            print("Found \(version.booksFileName) in bundle (alternate path) for \(version.displayName)")
            return URL(fileURLWithPath: bundlePath)
        }
        
        if let bundlePath = Bundle.main.path(forResource: "Books", ofType: "json", inDirectory: version.directoryName) {
            print("Found Books.json in bundle (alternate path) for \(version.displayName)")
            return URL(fileURLWithPath: bundlePath)
        }
        
        return nil
    }
    
    private func findBooksJsonInDocuments(for version: BibleVersion) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let bibleDirectory = documentsDirectory.appendingPathComponent(version.directoryName)
        
        // Try with version-specific filename first
        let versionBooksJsonPath = bibleDirectory.appendingPathComponent(version.booksFileName)
        if fileManager.fileExists(atPath: versionBooksJsonPath.path) {
            print("Found \(version.booksFileName) in documents directory for \(version.displayName)")
            return versionBooksJsonPath
        }
        
        // Fall back to standard Books.json
        let booksJsonPath = bibleDirectory.appendingPathComponent("Books.json")
        if fileManager.fileExists(atPath: booksJsonPath.path) {
            print("Found Books.json in documents directory for \(version.displayName)")
            return booksJsonPath
        }
        
        return nil
    }
    
    private func findProjectBiblePath(for version: BibleVersion) -> URL? {
        let fileManager = FileManager.default
        let currentDir = fileManager.currentDirectoryPath
        
        // Common paths where the Bible resources might be located in development
        let searchPaths = [
            "/KJVABibleApp/Resources/\(version.directoryName)",
            "/Resources/\(version.directoryName)",
            "/KJVABibleApp/KJVABibleApp/Resources/\(version.directoryName)"
        ]
        
        for path in searchPaths {
            let fullPath = currentDir + path
            
            // Try version-specific filename first
            let versionBooksJsonPath = fullPath + "/\(version.booksFileName)"
            if fileManager.fileExists(atPath: versionBooksJsonPath) {
                print("Found \(version.booksFileName) at: \(fullPath) for \(version.displayName)")
                return URL(fileURLWithPath: fullPath)
            }
            
            // Fall back to standard Books.json
            let booksJsonPath = fullPath + "/Books.json"
            if fileManager.fileExists(atPath: booksJsonPath) {
                print("Found Bible resources at: \(fullPath) for \(version.displayName)")
                return URL(fileURLWithPath: fullPath)
            }
        }
        
        return nil
    }
    
    private func loadBooksDirectly(from directory: URL, for version: BibleVersion) -> Bool {
        print("Attempting to load Bible data directly from directory: \(directory.path) for \(version.displayName)")
        
        do {
            let fileManager = FileManager.default
            let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            // Filter for .json files only (excluding Books.json)
            let jsonFiles = contents.filter { $0.pathExtension.lowercased() == "json" && $0.lastPathComponent != "Books.json" }
            
            var books = [String]()
            var bookDataDict = [String: BibleBook]()
            
            for file in jsonFiles {
                guard let bookData = try? parseBibleBookFile(url: file) else {
                    continue
                }
                
                let bookName = bookData.0
                let bibleBook = bookData.1
                
                books.append(bookName)
                bookDataDict[bookName] = bibleBook
            }
            
            if !bookDataDict.isEmpty {
                let bibleData = BibleData(books: books, bookData: bookDataDict)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.bibleDatas[version] = bibleData
                    if version == self.currentVersion {
                        self.books = bookDataDict
                    }
                    print("Successfully loaded Bible data with \(books.count) books for \(version.displayName)")
                    print("Successfully loaded Bible data from subdirectory: \(directory.lastPathComponent)")
                    
                    // Print book status
                    self.debugPrintBookStatus()
                }
                return true
            }
        } catch {
            print("Error loading Bible data for \(version.displayName): \(error)")
        }
        
        return false
    }
    
    private func createFallbackBibleData(for version: BibleVersion) {
        // Get the appropriate book lists for the selected version
        let bookList: [String]
        
        switch version.language {
        case .english:
            bookList = englishOldTestamentBooksList + englishNewTestamentBooksList + englishApocryphaBooksList
        case .spanish:
            bookList = spanishOldTestamentBooksList + spanishNewTestamentBooksList + spanishApocryphaBooksList
        }
        
        // Create a minimal structure with empty books but correct names
        var bookDataDict: [String: BibleBook] = [:]
        
        for book in bookList {
            // Create a sample chapter with a sample verse
            let sampleVerse = ["1": "Sample verse text for \(book) chapter 1, verse 1."]
            let chapters = [1: sampleVerse]
            
            let bibleBook = BibleBook(id: book.lowercased(), name: book, chapters: chapters)
            bookDataDict[book] = bibleBook
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let bibleData = BibleData(books: bookList, bookData: bookDataDict)
            self.bibleDatas[version] = bibleData
            if version == self.currentVersion {
                self.books = bookDataDict
            }
            print("Created fallback Bible data with \(bookList.count) books for \(version.displayName)")
        }
    }
    
    func getBook(_ name: String) -> BibleBook? {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        return bibleDatas[currentVersion]?.bookData[name]
    }
    
    func getVerse(book: String, chapter: Int, verse: Int) -> String? {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        
        guard let bookData = getBook(book),
              let chapterData = bookData.chapters[chapter],
              let verseText = chapterData[String(verse)] else {
            // Return a placeholder if the verse is not found
            return "Verse \(verse) text is not available."
        }
        
        // Process text based on user preference and only apply modernization to English KJV
        if currentVersion == .kjv && useModernEnglish {
            return textModernizer.processText(verseText, useModernEnglish: useModernEnglish)
        }
        return verseText
    }
    
    func getAllBooks() -> [String] {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        
        // Return the loaded books or fallback to our predefined lists
        if let books = bibleDatas[currentVersion]?.books, !books.isEmpty {
            return books
        }
        
        // Return appropriate book list based on current version
        switch currentVersion.language {
        case .english:
            return englishOldTestamentBooksList + englishNewTestamentBooksList + englishApocryphaBooksList
        case .spanish:
            return spanishOldTestamentBooksList + spanishNewTestamentBooksList + spanishApocryphaBooksList
        }
    }
    
    func getOldTestamentBooks() -> [String] {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        
        // Return loaded books if available, otherwise use predefined list
        if let books = bibleDatas[currentVersion]?.books, !books.isEmpty {
            return books.filter { oldTestamentBooks.contains($0) }
        }
        return oldTestamentBooks
    }
    
    func getNewTestamentBooks() -> [String] {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        
        // Return loaded books if available, otherwise use predefined list
        if let books = bibleDatas[currentVersion]?.books, !books.isEmpty {
            return books.filter { newTestamentBooks.contains($0) }
        }
        return newTestamentBooks
    }
    
    func getApocryphaBooks() -> [String] {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        
        // Return loaded books if available, otherwise use predefined list
        if let books = bibleDatas[currentVersion]?.books, !books.isEmpty {
            return books.filter { isApocryphaBook($0) }
        }
        return apocryphaBooks
    }
    
    func isApocryphaBook(_ book: String) -> Bool {
        // Check if the book is in the predefined apocrypha list
        if apocryphaBooks.contains(book) {
            return true
        }
        
        // Check if the book is not in OT or NT (additional apocrypha books that might be in the data)
        if oldTestamentBooks.contains(book) || newTestamentBooks.contains(book) {
            return false
        }
        
        // If the book exists but isn't in our predefined lists, assume it's apocrypha
        if bibleDatas[currentVersion]?.bookData[book] != nil {
            return true
        }
        
        return false
    }
    
    func debugPrintBookStatus() {
        print("\n=== Bible Book Status for \(currentVersion.displayName) ===")
        print("Total books: \(getAllBooks().count)")
        print("Old Testament: \(getOldTestamentBooks().count) books")
        print("New Testament: \(getNewTestamentBooks().count) books")
        print("Apocrypha: \(getApocryphaBooks().count) books")
    }
    
    func getChapterCount(book: String) -> Int {
        // Ensure data is loaded
        if bibleDatas[currentVersion] == nil && !isLoading {
            loadBibleDataIfNeeded(for: currentVersion)
        }
        
        guard let book = getBook(book) else { return 0 }
        return book.chapterCount
    }
    
    func getVerseCount(book: String, chapter: Int) -> Int {
        guard let bookData = getBook(book),
              let chapterData = bookData.chapters[chapter] else {
            return 0
        }
        return chapterData.count
    }
    
    private func parseBibleBookFile(url: URL) throws -> (String, BibleBook)? {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        do {
            let bibleBookJSON = try decoder.decode(BibleBookJSON.self, from: data)
            
            // Process the structure into our app's expected format
            let bookName = bibleBookJSON.book
            let id = bookName.lowercased().replacingOccurrences(of: " ", with: "-")
            
            var chapters: [Int: [String: String]] = [:]
            
            for chapter in bibleBookJSON.chapters {
                var verses: [String: String] = [:]
                
                for verse in chapter.verses {
                    verses[String(verse.verse)] = verse.text
                }
                
                chapters[chapter.chapter] = verses
            }
            
            let bibleBook = BibleBook(id: id, name: bookName, chapters: chapters)
            return (bookName, bibleBook)
        } catch {
            print("Error parsing Bible book file \(url.lastPathComponent): \(error)")
            return nil
        }
    }
    
    func toggleModernEnglish() {
        // Modern English toggle only applies to KJV
        useModernEnglish.toggle()
        UserDefaults.standard.set(useModernEnglish, forKey: "useModernEnglish")
    }
    
    func switchVersion(to version: BibleVersion) {
        // Check if we already have the data loaded
        if bibleDatas[version] == nil {
            // Load the data for the new version
            loadBibleDataIfNeeded(for: version)
        }
        
        // Update the current version
        currentVersion = version
        
        // Update the books from the new version
        if let bibleData = bibleDatas[version] {
            books = bibleData.bookData
        }
        
        // Save the selected version
        UserDefaults.standard.set(version.rawValue, forKey: "selectedBibleVersion")
    }
}

// MARK: - Environment Integration
private struct BibleDataManagerKey: EnvironmentKey {
    static let defaultValue: BibleDataManaging = BibleDataManager.shared
}

extension EnvironmentValues {
    var bibleDataManager: BibleDataManaging {
        get { self[BibleDataManagerKey.self] }
        set { self[BibleDataManagerKey.self] = newValue }
    }
}

// MARK: - Mock Bible Data Manager for Previews
class MockBibleDataManager: BibleDataManaging {
    static let mock = MockBibleDataManager()
    
    var oldTestamentBooks: [String] = ["Genesis", "Exodus", "Leviticus"]
    var newTestamentBooks: [String] = ["Matthew", "Mark", "Luke"]
    var apocryphaBooks: [String] = []
    var currentVersion: BibleVersion = .kjv
    
    func getBook(_ name: String) -> BibleBook? {
        let sampleVerses = ["1": "This is verse 1", "2": "This is verse 2", "3": "This is verse 3"]
        let chapters = [1: sampleVerses, 2: sampleVerses, 3: sampleVerses]
        return BibleBook(id: name.lowercased(), name: name, chapters: chapters)
    }
    
    func getVerse(book: String, chapter: Int, verse: Int) -> String? {
        return "Sample verse text for \(book) \(chapter):\(verse)."
    }
    
    func getAllBooks() -> [String] {
        return ["Genesis", "Exodus", "Leviticus", "Matthew", "Mark", "Luke", "John", "Tobit", "Judith"]
    }
    
    func getOldTestamentBooks() -> [String] {
        return ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy"]
    }
    
    func getNewTestamentBooks() -> [String] {
        return ["Matthew", "Mark", "Luke", "John", "Acts"]
    }
    
    func getApocryphaBooks() -> [String] {
        return ["Tobit", "Judith", "Wisdom of Solomon", "Ecclesiasticus"]
    }
    
    func isApocryphaBook(_ book: String) -> Bool {
        return getApocryphaBooks().contains(book)
    }
    
    func debugPrintBookStatus() {
        print("Mock Bible Data Manager - No real book data")
    }
    
    func getChapterCount(book: String) -> Int {
        return 1
    }
    
    func getVerseCount(book: String, chapter: Int) -> Int {
        return 1
    }
    
    func switchVersion(to version: BibleVersion) {
        currentVersion = version
    }
} 