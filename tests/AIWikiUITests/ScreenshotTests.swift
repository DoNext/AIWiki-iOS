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
        
        sleep(2)
        takeScreenshot(name: "\(deviceName)_01_Home")
        
        // Tap on Search (it's a textfield "搜索名称、简介、功能" or navigation title)
        // Wait, it's searchable. The search bar is accessible.
        let searchField = app.searchFields.firstMatch
        if searchField.exists {
            searchField.tap()
            searchField.typeText("Deep")
            sleep(2)
            takeScreenshot(name: "\(deviceName)_02_Search")
            
            app.buttons["Cancel"].tap() // Or keyboard "Dismiss"
        }
        
        // Tap first category
        app.tabBars.buttons["分类"].tap()
        sleep(1)
        takeScreenshot(name: "\(deviceName)_03_Categories")
        
        // Tap a tool to show details
        app.tabBars.buttons["首页"].tap()
        let toolButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'DeepSeek'")).firstMatch
        if toolButton.exists {
            toolButton.tap()
            sleep(1)
            takeScreenshot(name: "\(deviceName)_04_Detail")
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
