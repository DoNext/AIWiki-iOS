import XCTest

class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!
    var screenshotsDir: String!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")
        
        screenshotsDir = "/Users/yinchaoyu/Downloads/scratch/test-clone/beijing-camera-ios/screenshots"
        
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
        app.tabBars.buttons["首页"].tap()
        sleep(1)
        takeScreenshot(name: "\(deviceName)_01_Home")
        
        // 02 Prompt Studio (New)
        let promptStudioBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS '提示词工作室'")).firstMatch
        _ = promptStudioBtn.waitForExistence(timeout: 5)
        promptStudioBtn.tap()
        sleep(2)
        takeScreenshot(name: "\(deviceName)_02_PromptStudio")
        app.buttons["取消"].firstMatch.tap() // Correct label is "取消"
        sleep(1)
        
        // 03 Compare
        app.tabBars.buttons["对比"].tap()
        sleep(1)
        takeScreenshot(name: "\(deviceName)_03_Compare")
        
        // 04 Favorites
        app.tabBars.buttons["收藏"].tap()
        sleep(1)
        takeScreenshot(name: "\(deviceName)_04_Favorites")
        
        // 05 Dashboard (New - via Settings)
        app.tabBars.buttons["设置"].tap()
        sleep(1)
        let dashboardBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS '生产力仪表盘'")).firstMatch
        _ = dashboardBtn.waitForExistence(timeout: 5)
        dashboardBtn.tap()
        sleep(5) // Radar chart animation might take time
        takeScreenshot(name: "\(deviceName)_05_Dashboard")
    }

    func setupFavorites() {
        // Go to Home first
        let homeButton = app.tabBars.buttons["首页"]
        if homeButton.exists {
            homeButton.tap()
        }
        
        // Favorite a few tools from "热门推荐" or "新增工具"
        let toolQuery = app.scrollViews.otherElements.buttons.matching(NSPredicate(format: "label CONTAINS 'DeepSeek' OR label CONTAINS 'ChatGPT' OR label CONTAINS 'Midjourney'"))
        
        let count = min(toolQuery.count, 3)
        for i in 0..<count {
            let tool = toolQuery.element(boundBy: i)
            if tool.exists {
                tool.tap()
                sleep(1)
                
                let favoriteButton = app.scrollViews.buttons["收藏"]
                let alreadyFavorited = app.scrollViews.buttons["已收藏"]
                
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
}
