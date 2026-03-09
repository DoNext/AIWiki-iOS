import Foundation

extension AITool {
    var localizedName: String { L10n.text(name) }
    var localizedCompany: String { L10n.text(company) }
    var localizedIntro: String { L10n.text(intro) }
    var localizedCategory: String { L10n.text(category) }
    var localizedFeatures: [String] { features.map(L10n.text) }
    var localizedUseCases: [String]? { useCases?.map(L10n.text) }
    var localizedBestPractices: [String]? { bestPractices?.map(L10n.text) }
    var localizedStrengths: [String]? { strengths?.map(L10n.text) }
    var localizedLimitations: [String]? { limitations?.map(L10n.text) }
    var localizedPromptTemplates: [PromptTemplate] {
        (promptTemplates ?? []).map {
            .init(title: L10n.text($0.title), prompt: L10n.text($0.prompt))
        }
    }
    var localizedAccessPricing: String? { access.map { L10n.text($0.pricing) } }
    var localizedAccessPlatforms: [String]? { access?.platforms.map(L10n.text) }

    var localizedSearchText: String {
        let parts = [
            localizedName,
            id,
            localizedIntro,
            localizedCompany,
            localizedCategory
        ] + localizedFeatures
        return parts.joined(separator: " ").lowercased()
    }
}

extension LearningMaterial {
    var localizedName: String { L10n.text(name) }
    var localizedSummary: String { L10n.text(summary) }
    var localizedCoreCapabilities: [String] { coreCapabilities.map(L10n.text) }
    var localizedGettingStarted: [String] { gettingStarted.map(L10n.text) }
    var localizedCaveats: [String] { caveats.map(L10n.text) }
}
