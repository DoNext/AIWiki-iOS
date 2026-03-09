import AppKit
import Foundation

struct AppStoreConfig {
    let name: String
    let width: CGFloat
    let height: CGFloat
    let textY: CGFloat
    let textFont: CGFloat
    let screenX: CGFloat
    let screenY: CGFloat
    let screenW: CGFloat
    let screenRadius: CGFloat
}

let configs = [
    AppStoreConfig(name: "iPhone_6_7", width: 1290, height: 2796, textY: 280, textFont: 86, screenX: 115, screenY: 600, screenW: 1060, screenRadius: 80),
    AppStoreConfig(name: "iPhone_6_5", width: 1242, height: 2688, textY: 270, textFont: 82, screenX: 111, screenY: 576, screenW: 1020, screenRadius: 76),
    AppStoreConfig(name: "iPad_12_9", width: 2048, height: 2732, textY: 250, textFont: 110, screenX: 224, screenY: 550, screenW: 1600, screenRadius: 40),
    AppStoreConfig(name: "iPad_13", width: 2064, height: 2752, textY: 252, textFont: 112, screenX: 226, screenY: 555, screenW: 1612, screenRadius: 40)
]

struct LocalePack {
    let code: String
    let rawSourceDir: String
    let outputDir: String
    let screenTexts: [(String, String)]
}

let repoRoot = "/Users/yinchaoyu/Downloads/apps/AIWiki"
let screenshotsRoot = repoRoot + "/screenshots"

func makeLocalePack(from arguments: [String]) -> LocalePack {
    let locale = arguments.dropFirst().first ?? "zh-Hans"
    switch locale {
    case "en", "en-US":
        return LocalePack(
            code: "en-US",
            rawSourceDir: screenshotsRoot + "/raw/en-US",
            outputDir: screenshotsRoot + "/AppStore/en-US",
            screenTexts: [
                ("01_Home", "Find the right AI tool faster"),
                ("02_PromptStudio", "Draft stronger prompts in seconds"),
                ("03_Compare", "Compare tools side by side"),
                ("04_Favorites", "Build your personal AI toolkit"),
                ("05_Dashboard", "Track your AI usage patterns")
            ]
        )
    default:
        return LocalePack(
            code: "zh-Hans",
            rawSourceDir: screenshotsRoot + "/raw/zh-Hans",
            outputDir: screenshotsRoot + "/AppStore/zh-Hans",
            screenTexts: [
                ("01_Home", "快速找到合适的 AI 工具"),
                ("02_PromptStudio", "更快写出高质量提示词"),
                ("03_Compare", "并排比较工具差异"),
                ("04_Favorites", "沉淀你的常用工具库"),
                ("05_Dashboard", "查看你的 AI 使用轨迹")
            ]
        )
    }
}

let selectedLocalePack = makeLocalePack(from: CommandLine.arguments)

try? FileManager.default.createDirectory(atPath: selectedLocalePack.outputDir, withIntermediateDirectories: true)

func createGradient(context: CGContext, width: CGFloat, height: CGFloat) {
    let colors = [
        NSColor(red: 0.10, green: 0.10, blue: 0.12, alpha: 1.0).cgColor,
        NSColor(red: 0.05, green: 0.05, blue: 0.06, alpha: 1.0).cgColor
    ] as CFArray
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0.0, 1.0])!
    context.drawLinearGradient(gradient, start: CGPoint(x: width/2, y: height), end: CGPoint(x: width/2, y: 0), options: [])
}

func drawText(text: String, context: CGContext, config: AppStoreConfig) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    paragraphStyle.lineBreakMode = .byWordWrapping

    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.45)
    shadow.shadowBlurRadius = 10
    shadow.shadowOffset = CGSize(width: 0, height: -2)
    
    let attrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: config.textFont, weight: .bold),
        .foregroundColor: NSColor.white,
        .paragraphStyle: paragraphStyle,
        .shadow: shadow
    ]

    let string = NSAttributedString(string: text, attributes: attrs)
    let horizontalInset = config.width * 0.12
    let maxRect = CGRect(
        x: horizontalInset,
        y: config.height - config.textY - config.textFont * 3.2,
        width: config.width - horizontalInset * 2,
        height: config.textFont * 3.2
    )
    let measuredRect = string.boundingRect(
        with: maxRect.size,
        options: [.usesLineFragmentOrigin, .usesFontLeading]
    )
    let drawRect = CGRect(
        x: maxRect.minX,
        y: maxRect.midY - ceil(measuredRect.height) / 2,
        width: maxRect.width,
        height: ceil(measuredRect.height)
    )

    string.draw(
        with: drawRect,
        options: [.usesLineFragmentOrigin, .usesFontLeading]
    )
}

func process() {
    for config in configs {
        for (suffix, marketingText) in selectedLocalePack.screenTexts {
            // Find the raw screenshot
            // Raw screenshots are captured from the current simulator lineup.
            let sourcePrefix = config.name.contains("iPad") ? "iPad_Pro_13-inch_(M5)" : "iPhone_17_Pro_Max"
            let imagePath = "\(selectedLocalePack.rawSourceDir)/\(sourcePrefix)_\(suffix).png"
            
            guard let rawImage = NSImage(contentsOfFile: imagePath) else {
                print("Missing raw image: \(imagePath)")
                continue
            }
            
            guard let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(config.width), pixelsHigh: Int(config.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0) else { continue }
            
            NSGraphicsContext.saveGraphicsState()
            let context = NSGraphicsContext(bitmapImageRep: bitmapRep)
            NSGraphicsContext.current = context
            guard let cgContext = context?.cgContext else { continue }
            
            // AppKit puts 0,0 at bottom left. We will keep it this way and do math.
            
            // 1. Draw Background
            createGradient(context: cgContext, width: config.width, height: config.height)
            
            // 2. Draw Text
            drawText(text: marketingText, context: cgContext, config: config)
            
            // 3. Draw Screenshot with rounded corners
            let screenRatio = rawImage.size.height / rawImage.size.width
            let screenH = config.screenW * screenRatio
            let rectY = config.height - config.screenY - screenH
            let screenRect = CGRect(x: config.screenX, y: rectY, width: config.screenW, height: screenH)
            
            let path = NSBezierPath(roundedRect: screenRect, xRadius: config.screenRadius, yRadius: config.screenRadius)
            
            // Draw a subtle border/shadow
            cgContext.saveGState()
            cgContext.setShadow(offset: CGSize(width: 0, height: -20), blur: 40, color: NSColor.black.withAlphaComponent(0.5).cgColor)
            NSColor.white.withAlphaComponent(0.2).setStroke()
            path.lineWidth = 4
            path.stroke()
            cgContext.restoreGState()
            
            // Clip to rounded rect and draw image
            path.addClip()
            // NSImage draw in unflipped context
            rawImage.draw(
                in: screenRect,
                from: NSRect(x: 0, y: 0, width: rawImage.size.width, height: rawImage.size.height),
                operation: NSCompositingOperation.copy,
                fraction: 1.0
            )
            
            NSGraphicsContext.restoreGraphicsState()
            
            if let data = bitmapRep.representation(using: .png, properties: [:]) {
                let outPath = "\(selectedLocalePack.outputDir)/\(config.name)_\(suffix).png"
                try? data.write(to: URL(fileURLWithPath: outPath))
                print("Generated \(outPath)")
            }
        }
    }
}

process()
