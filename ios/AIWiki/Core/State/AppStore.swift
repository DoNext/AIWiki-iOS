import Foundation

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var tools: [AITool] = []
    @Published private(set) var learningByToolID: [String: LearningMaterial] = [:]
    @Published private(set) var loadError: String?
    @Published private(set) var favoriteIDs: Set<String>
    @Published private(set) var bookmarkedScenarioIDs: Set<String>
    @Published private(set) var scenarioProgress: [String: Set<Int>]
    @Published private(set) var scenarioNotes: [String: String]
    @Published private(set) var toolRatings: [String: Int]
    @Published private(set) var toolNotes: [String: String]
    @Published private(set) var checkInEvents: [CheckInEvent]
    @Published var theme: AppTheme {
        didSet { userDefaults.set(theme.rawValue, forKey: Keys.theme) }
    }

    private let repository: ToolRepository
    private let learningRepository: LearningMaterialRepository
    private let userDefaults: UserDefaults

    init(
        repository: ToolRepository = ToolSeedStore(),
        learningRepository: LearningMaterialRepository = LearningMaterialSeedStore(),
        userDefaults: UserDefaults = .standard
    ) {
        self.repository = repository
        self.learningRepository = learningRepository
        self.userDefaults = userDefaults

        let savedIDs = userDefaults.array(forKey: Keys.favorites) as? [String] ?? []
        self.favoriteIDs = Set(savedIDs)
        let savedScenarioIDs = userDefaults.array(forKey: Keys.scenarioBookmarks) as? [String] ?? []
        self.bookmarkedScenarioIDs = Set(savedScenarioIDs)
        let rawProgress = userDefaults.dictionary(forKey: Keys.scenarioProgress) as? [String: [Int]] ?? [:]
        self.scenarioProgress = rawProgress.reduce(into: [:]) { partialResult, item in
            partialResult[item.key] = Set(item.value)
        }
        self.scenarioNotes = userDefaults.dictionary(forKey: Keys.scenarioNotes) as? [String: String] ?? [:]
        self.toolRatings = userDefaults.dictionary(forKey: Keys.toolRatings) as? [String: Int] ?? [:]
        self.toolNotes = userDefaults.dictionary(forKey: Keys.toolNotes) as? [String: String] ?? [:]
        
        if let data = userDefaults.data(forKey: Keys.checkIns),
           let events = try? JSONDecoder().decode([CheckInEvent].self, from: data) {
            self.checkInEvents = events
        } else {
            self.checkInEvents = []
        }

        if let rawTheme = userDefaults.string(forKey: Keys.theme),
           let value = AppTheme(rawValue: rawTheme) {
            self.theme = value
        } else {
            self.theme = .dark
        }

        loadTools()
    }

    func loadTools() {
        do {
            tools = try repository.fetchAll()
            loadError = nil
        } catch {
            tools = []
            learningByToolID = [:]
            loadError = error.localizedDescription
            return
        }

        do {
            let learningMaterials = try learningRepository.fetchAllLearningMaterials()
            learningByToolID = learningMaterials.reduce(into: [String: LearningMaterial]()) { result, material in
                // Keep the first material encountered for a given ID to avoid duplicate key crash
                if result[material.id] == nil {
                    result[material.id] = material
                }
            }
        } catch {
            learningByToolID = [:]
        }
    }

    func learningMaterial(for toolID: String) -> LearningMaterial? {
        learningByToolID[toolID]
    }

    func filteredTools(query: String) -> [AITool] {
        rankAndFilter(tools: tools, query: query)
    }

    func categoryGroups() -> [(name: String, count: Int)] {
        let grouped = Dictionary(grouping: tools, by: \.category)
        return grouped
            .map { ($0.key, $0.value.count) }
            .sorted { $0.0.localizedCompare($1.0) == .orderedAscending }
    }

    func tools(in category: String) -> [AITool] {
        tools
            .filter { $0.category == category }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    func tool(withID id: String) -> AITool? {
        tools.first { $0.id == id }
    }

    func filteredTools(in category: String, query: String) -> [AITool] {
        rankAndFilter(tools: tools(in: category), query: query)
    }

    func favoriteTools() -> [AITool] {
        tools
            .filter { favoriteIDs.contains($0.id) }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteIDs.contains(id)
    }

    func toggleFavorite(_ id: String) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
        persistFavorites()
    }

    func clearFavorites() {
        favoriteIDs.removeAll()
        persistFavorites()
    }

    func isScenarioBookmarked(_ scenarioID: String) -> Bool {
        bookmarkedScenarioIDs.contains(scenarioID)
    }

    func toggleScenarioBookmark(_ scenarioID: String) {
        if bookmarkedScenarioIDs.contains(scenarioID) {
            bookmarkedScenarioIDs.remove(scenarioID)
        } else {
            bookmarkedScenarioIDs.insert(scenarioID)
        }
        persistScenarioBookmarks()
    }

    func isQuickStepCompleted(scenarioID: String, stepIndex: Int) -> Bool {
        scenarioProgress[scenarioID, default: []].contains(stepIndex)
    }

    func toggleQuickStepCompleted(scenarioID: String, stepIndex: Int) {
        var completed = scenarioProgress[scenarioID, default: []]
        if completed.contains(stepIndex) {
            completed.remove(stepIndex)
        } else {
            completed.insert(stepIndex)
        }
        scenarioProgress[scenarioID] = completed
        persistScenarioProgress()
    }

    func completedQuickStepCount(scenarioID: String) -> Int {
        scenarioProgress[scenarioID, default: []].count
    }

    func resetQuickSteps(scenarioID: String) {
        scenarioProgress[scenarioID] = []
        persistScenarioProgress()
    }

    func note(for scenarioID: String) -> String {
        scenarioNotes[scenarioID, default: ""]
    }

    func updateNote(for scenarioID: String, text: String) {
        scenarioNotes[scenarioID] = text
        persistScenarioNotes()
    }

    // MARK: - Tool Ratings & Notes

    func rating(for toolID: String) -> Int {
        toolRatings[toolID, default: 0]
    }

    func rate(toolID: String, score: Int) {
        toolRatings[toolID] = max(0, min(5, score))
        persistToolRatings()
    }

    func toolNote(for toolID: String) -> String {
        toolNotes[toolID, default: ""]
    }

    func updateToolNote(toolID: String, text: String) {
        toolNotes[toolID] = text.isEmpty ? nil : text
        persistToolNotes()
    }

    // MARK: - Check-ins

    func checkIn(tool: AITool) {
        let event = CheckInEvent(toolID: tool.id, date: Date(), category: tool.category)
        checkInEvents.append(event)
        persistCheckIns()
    }

    func checkInsInLast7Days() -> [CheckInEvent] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return checkInEvents.filter { $0.date >= weekAgo }
    }

    func clearCheckIns() {
        checkInEvents.removeAll()
        persistCheckIns()
    }

    // MARK: - Recommendations

    func recommendedTools() -> [AITool] {
        // Collect categories the user has engaged with (favorites + rated)
        let engagedIDs = favoriteIDs.union(Set(toolRatings.filter { $0.value >= 3 }.keys))

        if engagedIDs.isEmpty {
            // New user: show a diverse selection — one tool per category
            let grouped = Dictionary(grouping: tools, by: \.category)
            return Array(grouped.values
                .compactMap { $0.first }
                .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
                .prefix(6))
        }

        let engagedCategories = tools
            .filter { engagedIDs.contains($0.id) }
            .map(\.category)
        let categorySet = Set(engagedCategories)

        // Recommend tools from same categories that user hasn't engaged with
        let candidates = tools.filter { tool in
            categorySet.contains(tool.category) && !engagedIDs.contains(tool.id)
        }

        // Sort by name, take up to 6
        return Array(candidates
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
            .prefix(6))
    }

    private func persistFavorites() {
        userDefaults.set(Array(favoriteIDs).sorted(), forKey: Keys.favorites)
    }

    private func persistScenarioBookmarks() {
        userDefaults.set(Array(bookmarkedScenarioIDs).sorted(), forKey: Keys.scenarioBookmarks)
    }

    private func persistScenarioProgress() {
        let payload = scenarioProgress.reduce(into: [String: [Int]]()) { partialResult, item in
            partialResult[item.key] = Array(item.value).sorted()
        }
        userDefaults.set(payload, forKey: Keys.scenarioProgress)
    }

    private func persistScenarioNotes() {
        userDefaults.set(scenarioNotes, forKey: Keys.scenarioNotes)
    }

    private func persistToolRatings() {
        userDefaults.set(toolRatings, forKey: Keys.toolRatings)
    }

    private func persistToolNotes() {
        userDefaults.set(toolNotes, forKey: Keys.toolNotes)
    }

    private func persistCheckIns() {
        if let data = try? JSONEncoder().encode(checkInEvents) {
            userDefaults.set(data, forKey: Keys.checkIns)
        }
    }

    private func score(tool: AITool, tokens: [String]) -> Int {
        let name = tool.name.lowercased()
        let intro = tool.intro.lowercased()
        let features = tool.features.joined(separator: " ").lowercased()

        var score = 0
        for token in tokens {
            if name.contains(token) { score += 5 }
            if intro.contains(token) { score += 3 }
            if features.contains(token) { score += 2 }
        }
        return score
    }

    private func rankAndFilter(tools: [AITool], query: String) -> [AITool] {
        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !keyword.isEmpty else { return tools }

        let tokens = keyword
            .split(whereSeparator: \.isWhitespace)
            .map(String.init)
            .filter { !$0.isEmpty }

        guard !tokens.isEmpty else { return tools }

        return tools
            .compactMap { tool in
                let score = score(tool: tool, tokens: tokens)
                return score > 0 ? (tool, score) : nil
            }
            .sorted { lhs, rhs in
                if lhs.1 == rhs.1 {
                    return lhs.0.name.localizedCompare(rhs.0.name) == .orderedAscending
                }
                return lhs.1 > rhs.1
            }
            .map(\.0)
    }
}

private enum Keys {
    static let favorites = "aiwiki.favorites"
    static let theme = "aiwiki.theme"
    static let scenarioBookmarks = "aiwiki.scenarioBookmarks"
    static let scenarioProgress = "aiwiki.scenarioProgress"
    static let scenarioNotes = "aiwiki.scenarioNotes"
    static let toolRatings = "aiwiki.toolRatings"
    static let toolNotes = "aiwiki.toolNotes"
    static let checkIns = "aiwiki.checkIns"
}

struct CheckInEvent: Codable, Identifiable {
    var id = UUID()
    let toolID: String
    let date: Date
    let category: String
}
