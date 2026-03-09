import XCTest

class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!
    var screenshotsDir: String!
    var localeCode: String!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")

        let preferredLanguage = Locale.preferredLanguages.first ?? "zh-Hans"
        localeCode = preferredLanguage.hasPrefix("en") ? "en-US" : "zh-Hans"
        screenshotsDir = "/Users/yinchaoyu/Downloads/apps/AIWiki/screenshots/raw/\(localeCode!)"
        
        let fm = FileManager.default
        if !fm.fileExists(atPath: screenshotsDir) {
            try fm.createDirectory(atPath: screenshotsDir, withIntermediateDirectories: true)
        }
        app.launch()
    }

    func testCaptureScreenshots() throws {
        let deviceName = UIDevice.current.name.replacingOccurrences(of: " ", with: "_")
        
        // Setup data
        setupFavorites()
        
        // 01 Home
        tapTab(labels: ["首页", "Home"])
        sleep(1)
        takeScreenshot(name: "\(deviceName)_01_Home")
        
        // 02 Prompt Studio (New)
        let promptStudioBtn = firstElement(
            matchingAnyOf: [
                NSPredicate(format: "label CONTAINS '提示词工作室'"),
                NSPredicate(format: "label CONTAINS 'Prompt Studio'")
            ],
            in: app.buttons
        )
        _ = promptStudioBtn.waitForExistence(timeout: 5)
        promptStudioBtn.tap()
        sleep(2)
        takeScreenshot(name: "\(deviceName)_02_PromptStudio")
        tapFirst(labels: ["取消", "Cancel"], in: app.buttons)
        sleep(1)
        
        // 03 Compare
        tapTab(labels: ["对比", "Compare"])
        sleep(1)
        takeScreenshot(name: "\(deviceName)_03_Compare")
        
        // 04 Favorites
        tapTab(labels: ["收藏", "Favorites"])
        sleep(1)
        takeScreenshot(name: "\(deviceName)_04_Favorites")
        
        // 05 Dashboard (New - via Settings)
        tapTab(labels: ["设置", "Settings"])
        sleep(1)
        let dashboardBtn = firstElement(
            matchingAnyOf: [
                NSPredicate(format: "label CONTAINS '生产力仪表盘'"),
                NSPredicate(format: "label CONTAINS 'Dashboard'")
            ],
            in: app.buttons
        )
        _ = dashboardBtn.waitForExistence(timeout: 5)
        dashboardBtn.tap()
        sleep(5) // Radar chart animation might take time
        takeScreenshot(name: "\(deviceName)_05_Dashboard")
    }

    func setupFavorites() {
        // Go to Home first
        tapTab(labels: ["首页", "Home"])
        
        // Favorite a few tools from "热门推荐" or "新增工具"
        let toolQuery = app.scrollViews.otherElements.buttons.matching(NSPredicate(format: "label CONTAINS 'DeepSeek' OR label CONTAINS 'ChatGPT' OR label CONTAINS 'Midjourney'"))
        
        let count = min(toolQuery.count, 3)
        for i in 0..<count {
            let tool = toolQuery.element(boundBy: i)
            if tool.exists {
                tool.tap()
                sleep(1)
                
                let favoriteButton = firstElement(
                    matchingAnyOf: [
                        NSPredicate(format: "label == '收藏'"),
                        NSPredicate(format: "label == 'Favorite'")
                    ],
                    in: app.scrollViews.buttons
                )
                let alreadyFavorited = firstElement(
                    matchingAnyOf: [
                        NSPredicate(format: "label == '已收藏'"),
                        NSPredicate(format: "label == 'Favorited'")
                    ],
                    in: app.scrollViews.buttons
                )
                
                if alreadyFavorited.exists {
                    // Already favorited, do nothing
                } else if favoriteButton.exists {
                    favoriteButton.tap()
                    sleep(1)
                }
                
                // Go back using the back button in the navigation bar
                let backButton = app.navigationBars.buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    sleep(1)
                }
            }
        }
    }

    func dismissNotifications() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        // Target specific Apple Intelligence or other notification banners
        let notification = springboard.otherElements.matching(NSPredicate(format: "label CONTAINS '智能' OR label CONTAINS 'Notification'")).firstMatch
        if notification.exists && notification.isHittable {
            notification.swipeUp()
            sleep(1)
        }
    }

    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let path = (screenshotsDir as NSString).appendingPathComponent("\(name).png")
        do {
            try screenshot.pngRepresentation.write(to: URL(fileURLWithPath: path))
            print("Saved screenshot to \(path)")
        } catch {
            print("Failed to save screenshot: \(error)")
        }
    }

    private func tapTab(labels: [String]) {
        for label in labels {
            let tabButton = app.tabBars.buttons[label].firstMatch
            if tabButton.waitForExistence(timeout: 1) {
                tabButton.tap()
                return
            }

            let directButton = app.buttons[label].firstMatch
            if directButton.waitForExistence(timeout: 1) {
                directButton.tap()
                return
            }

            let sidebarButton = app.collectionViews.buttons[label].firstMatch
            if sidebarButton.waitForExistence(timeout: 1) {
                sidebarButton.tap()
                return
            }

            let outlineButton = app.outlines.buttons[label].firstMatch
            if outlineButton.waitForExistence(timeout: 1) {
                outlineButton.tap()
                return
            }
        }

        XCTFail("Could not find any tab label in \(labels)")
    }

    private func tapFirst(labels: [String], in query: XCUIElementQuery) {
        for label in labels {
            let element = query[label].firstMatch
            if element.waitForExistence(timeout: 2) {
                element.tap()
                return
            }
        }
        XCTFail("Could not find any label in \(labels)")
    }

    private func firstElement(matchingAnyOf predicates: [NSPredicate], in query: XCUIElementQuery) -> XCUIElement {
        for predicate in predicates {
            let element = query.matching(predicate).firstMatch
            if element.exists {
                return element
            }
        }
        return query.element(boundBy: 0)
    }
}
