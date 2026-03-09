import Foundation

struct AITool: Codable, Identifiable, Hashable {
    struct PromptTemplate: Codable, Hashable {
        let title: String
        let prompt: String
    }

    struct AccessInfo: Codable, Hashable {
        let pricing: String
        let accountRequired: Bool
        let platforms: [String]
        let apiAvailable: Bool

        enum CodingKeys: String, CodingKey {
            case pricing
            case accountRequired = "account_required"
            case platforms
            case apiAvailable = "api_available"
        }
    }

    let id: String
    let name: String
    let intro: String
    let features: [String]
    let company: String
    let url: String
    let icon: String
    let category: String
    let sourceURL: String
    let lastVerifiedAt: String
    let useCases: [String]?
    let bestPractices: [String]?
    let strengths: [String]?
    let limitations: [String]?
    let promptTemplates: [PromptTemplate]?
    let access: AccessInfo?
    let radarScores: [String: Int]?

    var radarScoresOrDefault: [String: Int] {
        if let scores = radarScores, !scores.isEmpty {
            return scores
        }

        // Generate deterministic "best guess" scores based on localized content,
        // so future semantic-key seed data continues to behave correctly.
        let count = (features.count + (useCases?.count ?? 0))
        let base = min(5, max(3, count / 2))
        let multimodalText = (localizedFeatures + (localizedUseCases ?? [])).joined(separator: " ").lowercased()
        let pricingText = ((localizedAccessPricing ?? access?.pricing) ?? "").lowercased()

        return [
            "reasoning": base,
            "multimodal": multimodalText.contains("图像")
                || multimodalText.contains("视频")
                || multimodalText.contains("image")
                || multimodalText.contains("video") ? 5 : 2,
            "speed": base,
            "cost": pricingText.contains("免费")
                || pricingText.contains("free")
                || pricingText.contains("open source")
                || pricingText.contains("开源") ? 5 : 3,
            "easeOfUse": 4
        ]
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case intro
        case features
        case company
        case url
        case icon
        case category
        case sourceURL = "source_url"
        case lastVerifiedAt = "last_verified_at"
        case useCases = "use_cases"
        case bestPractices = "best_practices"
        case strengths
        case limitations
        case promptTemplates = "prompt_templates"
        case access
        case radarScores = "radar_scores"
    }
}


struct LearningMaterial: Codable, Hashable {
    let id: String
    let name: String
    let summary: String
    let coreCapabilities: [String]
    let gettingStarted: [String]
    let officialLinks: [String]
    let caveats: [String]
    let lastVerifiedAt: String
    let reviewStatus: String
    let reviewNote: String
    let rawFile: String
    let fetchedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case summary
        case coreCapabilities = "core_capabilities"
        case gettingStarted = "getting_started"
        case officialLinks = "official_links"
        case caveats
        case lastVerifiedAt = "last_verified_at"
        case reviewStatus = "review_status"
        case reviewNote = "review_note"
        case rawFile = "raw_file"
        case fetchedAt = "fetched_at"
    }
}
