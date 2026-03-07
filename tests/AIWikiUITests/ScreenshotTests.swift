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
        
        let tabs = ["首页", "分类", "对比", "收藏", "设置"]
        let suffixes = ["01_Home", "02_Categories", "03_Compare", "04_Favorites", "05_Settings"]
        
        for (index, tabName) in tabs.enumerated() {
            let tabButton = app.tabBars.buttons[tabName]
            if tabButton.exists {
                tabButton.tap()
                sleep(2)
                dismissNotifications()
                takeScreenshot(name: "\(deviceName)_\(suffixes[index])")
            }
        }
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
