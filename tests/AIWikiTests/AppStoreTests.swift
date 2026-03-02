import XCTest
@testable import AIWiki

@MainActor
final class AppStoreTests: XCTestCase {
    private var suiteName: String!
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "AIWikiTests-\(UUID().uuidString)"
        userDefaults = UserDefaults(suiteName: suiteName)
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)
        userDefaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testSearchReturnsExpectedTool() {
        let store = makeStore()
        let results = store.filteredTools(query: "github")
        XCTAssertEqual(results.map(\.id), ["copilot"])
    }

    func testCategoryFilterReturnsOnlyCategoryTools() {
        let store = makeStore()
        let results = store.tools(in: "聊天机器人")
        XCTAssertEqual(results.map(\.id), ["chatgpt"])
    }

    func testToggleFavoriteAndClearFavorites() {
        let store = makeStore()

        store.toggleFavorite("chatgpt")
        XCTAssertTrue(store.isFavorite("chatgpt"))
        XCTAssertEqual(store.favoriteTools().map(\.id), ["chatgpt"])

        store.clearFavorites()
        XCTAssertFalse(store.isFavorite("chatgpt"))
        XCTAssertTrue(store.favoriteTools().isEmpty)
    }

    private func makeStore() -> AppStore {
        AppStore(
            repository: MockToolRepository(tools: Fixture.tools),
            userDefaults: userDefaults
        )
    }
}
