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

let screens = [
    ("01_Home", "一键开启 AI 知识之旅"),
    ("03_Categories", "分类浏览，一目了然"),
    ("04_Detail", "每个工具，深度解析")
]

let baseDir = "/Users/yinchaoyu/Downloads/scratch/test-clone/beijing-camera-ios/screenshots"
let outputDir = baseDir + "/AppStore"

try? FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

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
    
    let attrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: config.textFont, weight: .bold),
        .foregroundColor: NSColor.white,
        .paragraphStyle: paragraphStyle
    ]
    
    let string = NSAttributedString(string: text, attributes: attrs)
    // CGContext coordinates are bottom-left for AppKit.
    // textY was defined from the top. We convert it to distance from bottom.
    let rectY = config.height - config.textY - config.textFont * 2
    let rect = CGRect(x: 0, y: rectY, width: config.width, height: config.textFont * 2)
    string.draw(in: rect)
}

func process() {
    for config in configs {
        for (suffix, marketingText) in screens {
            // Find the raw screenshot
            // For iPhone configs, use iPhone_15_Pro_Max raw screenshots
            // For iPad configs, use iPad_Pro_(12.9-inch)_(6th_generation) screenshots
            let sourcePrefix = config.name.contains("iPad") ? "iPad_Pro_(12.9-inch)_(6th_generation)" : "iPhone_15_Pro_Max"
            let imagePath = "\(baseDir)/\(sourcePrefix)_\(suffix).png"
            
            guard let rawImage = NSImage(contentsOfFile: imagePath) else {
                print("Missing raw image: \(imagePath)")
                continue
            }
            
            let destRect = CGRect(x: 0, y: 0, width: config.width, height: config.height)
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
            rawImage.draw(in: screenRect, from: NSRect(x: 0, y: 0, width: rawImage.size.width, height: rawImage.size.height), operation: .copy, fraction: 1.0)
            
            NSGraphicsContext.restoreGraphicsState()
            
            if let data = bitmapRep.representation(using: .png, properties: [:]) {
                let outPath = "\(outputDir)/\(config.name)_\(suffix).png"
                try? data.write(to: URL(fileURLWithPath: outPath))
                print("Generated \(outPath)")
            }
        }
    }
}

process()
