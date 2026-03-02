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
