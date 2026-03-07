import Foundation
@preconcurrency import CoreSpotlight
import UniformTypeIdentifiers

@MainActor
class SpotlightManager {
    static let shared = SpotlightManager()
    
    private init() {}
    
    func indexTools(_ tools: [AITool]) {
        print("Spotlight: Starting indexing for \(tools.count) tools...")
        
        guard !tools.isEmpty else {
            print("Spotlight: ABORT - No tools to index.")
            return
        }
        
        let searchableItems = tools.map { tool -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(contentType: .data)
            attributeSet.title = tool.name
            attributeSet.displayName = tool.name
            attributeSet.contentDescription = tool.intro
            
            var keywords = [tool.category, tool.company, "AI", "工具", "助手"] + tool.features
            keywords.append(tool.id)
            attributeSet.keywords = keywords
            attributeSet.alternateNames = [tool.id]
            
            print("Spotlight: Preparing item [\(tool.id)] -> \(tool.name)")
            
            return CSSearchableItem(
                uniqueIdentifier: tool.id,
                domainIdentifier: Bundle.main.bundleIdentifier ?? "com.next.wiki",
                attributeSet: attributeSet
            )
        }
        
        print("Spotlight: Clearing old index...")
        CSSearchableIndex.default().deleteAllSearchableItems { error in
            if let error = error {
                print("Spotlight: Clear ERROR - \(error.localizedDescription)")
            } else {
                print("Spotlight: Clear SUCCESS. Now indexing...")
                CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
                    if let error = error {
                        print("Spotlight: Indexing ERROR - \(error.localizedDescription)")
                    } else {
                        print("Spotlight: Indexing SUCCESS for \(tools.count) items.")
                        if let first = tools.first {
                            print("Spotlight: Verify by searching for '\(first.name)' or '\(first.category)'")
                        }
                    }
                }
            }
        }
    }
    
    func clearIndex() {
        CSSearchableIndex.default().deleteAllSearchableItems { error in
            if let error = error {
                print("Spotlight clear error: \(error.localizedDescription)")
            }
        }
    }
}
