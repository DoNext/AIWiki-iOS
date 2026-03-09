import Foundation

enum L10n {
    static func text(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }

    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: text(key), locale: Locale.current, arguments: arguments)
    }

    enum Tab {
        static let home = "tab.home"
        static let categories = "tab.categories"
        static let compare = "tab.compare"
        static let favorites = "tab.favorites"
        static let settings = "tab.settings"
    }

    enum Common {
        static let done = "common.done"
        static let close = "common.close"
        static let cancel = "common.cancel"
        static let save = "common.save"
        static let clear = "common.clear"
        static let copy = "common.copy"
        static let copied = "common.copied"
        static let yes = "common.yes"
        static let no = "common.no"
        static let ok = "common.ok"
        static let delete = "common.delete"
        static let company = "common.company"
        static let category = "common.category"
        static let pricing = "common.pricing"
        static let platform = "common.platform"
        static let api = "common.api"
    }

    enum Home {
        static let title = "home.title"
        static let searchPlaceholder = "home.search.placeholder"
        static let quiz = "home.quiz"
        static let consoleTitle = "home.console.title"
        static let consoleSubtitle = "home.console.subtitle"
        static let promptStudioTitle = "home.prompt_studio.title"
        static let promptStudioSubtitle = "home.prompt_studio.subtitle"
        static let featured = "home.featured"
        static let recommended = "home.recommended"
        static let recent = "home.recent"
        static let bookmarked = "home.bookmarked"
        static let scenarios = "home.scenarios"
    }

    enum Search {
        static let title = "search.title"
        static let prompt = "search.prompt"
        static let inCategoryPrompt = "search.in_category_prompt"
        static let favoritesPrompt = "search.favorites_prompt"
        static let hot = "search.hot"
        static let history = "search.history"
        static let noResults = "search.no_results"
        static let noCategoryResults = "search.no_category_results"
    }

    enum Favorites {
        static let title = "favorites.title"
        static let empty = "favorites.empty"
        static let emptyHint = "favorites.empty_hint"
        static let noMatch = "favorites.no_match"
        static let sort = "favorites.sort"
        static let sortAZ = "favorites.sort_az"
        static let sortZA = "favorites.sort_za"
        static let clearAll = "favorites.clear_all"
    }

    enum Categories {
        static let title = "categories.title"
        static let toolCount = "categories.toolCount"
    }

    enum Category {
        static let writing = "category.writing"
        static let productivity = "category.productivity"
        static let imageGeneration = "category.image_generation"
        static let multimodal = "category.multimodal"
        static let search = "category.search"
        static let education = "category.education"
        static let dataAnalysis = "category.data_analysis"
        static let coding = "category.coding"
        static let chat = "category.chat"
        static let marketing = "category.marketing"
        static let video = "category.video"
        static let design = "category.design"
        static let audio = "category.audio"
    }

    enum Compare {
        static let title = "compare.title"
        static let toolA = "compare.tool_a"
        static let toolB = "compare.tool_b"
        static let exportTitle = "compare.export_title"
        static let exportSubtitle = "compare.export_subtitle"
        static let versus = "compare.vs"
        static let emptyTitle = "compare.empty_title"
        static let emptySubtitle = "compare.empty_subtitle"
        static let coreFeatures = "compare.core_features"
        static let strengths = "compare.strengths"
        static let limitations = "compare.limitations"
        static let recommendation = "compare.recommendation"
        static let unrated = "compare.unrated"
        static let apiYes = "compare.api_yes"
        static let apiNo = "compare.api_no"
        static let chooseTool = "compare.choose_tool"
        static let searchPrompt = "compare.search_prompt"
    }

    enum Detail {
        static let title = "detail.title"
        static let intro = "detail.intro"
        static let features = "detail.features"
        static let learningSummary = "detail.learning_summary"
        static let coreCapabilities = "detail.core_capabilities"
        static let gettingStarted = "detail.getting_started"
        static let officialLinks = "detail.official_links"
        static let caveats = "detail.caveats"
        static let useCases = "detail.use_cases"
        static let bestPractices = "detail.best_practices"
        static let promptTemplates = "detail.prompt_templates"
        static let strengths = "detail.strengths"
        static let limitations = "detail.limitations"
        static let radar = "detail.radar"
        static let myRating = "detail.my_rating"
        static let notes = "detail.notes"
        static let notePlaceholder = "detail.note_placeholder"
        static let editNote = "detail.edit_note"
        static let basicInfo = "detail.basic_info"
        static let accountRequired = "detail.account_required"
        static let openNow = "detail.open_now"
        static let copyLink = "detail.copy_link"
        static let generateCard = "detail.generate_card"
        static let generating = "detail.generating"
        static let checkIn = "detail.check_in"
        static let checkedIn = "detail.checked_in"
        static let favorite = "detail.favorite"
        static let favorited = "detail.favorited"
        static let sharePrefix = "detail.share_prefix"
        static let previewTitle = "detail.preview_title"
        static let favoriteAccessibilityAdd = "detail.favorite_accessibility_add"
        static let favoriteAccessibilityRemove = "detail.favorite_accessibility_remove"
    }

    enum Settings {
        static let title = "settings.title"
        static let theme = "settings.theme"
        static let appearance = "settings.appearance"
        static let stats = "settings.stats"
        static let dashboard = "settings.dashboard"
        static let toolCount = "settings.tool_count"
        static let categoryCount = "settings.category_count"
        static let favoriteCount = "settings.favorite_count"
        static let library = "settings.library"
        static let promptLibrary = "settings.prompt_library"
        static let support = "settings.support"
        static let rate = "settings.rate"
        static let share = "settings.share"
        static let feedback = "settings.feedback"
        static let appInfo = "settings.app_info"
        static let version = "settings.version"
        static let mode = "settings.mode"
        static let offline = "settings.offline"
        static let dataSource = "settings.data_source"
        static let dataSourceDesc = "settings.data_source_desc"
        static let shareTemplate = "settings.share_template"
    }

    enum Theme {
        static let system = "theme.system"
        static let light = "theme.light"
        static let dark = "theme.dark"
    }

    enum Console {
        static let title = "console.title"
        static let openPromptStudio = "console.open_prompt_studio"
        static let tip = "console.tip"
    }

    enum Quiz {
        static let title = "quiz.title"
        static let matching = "quiz.matching"
        static let resultTitle = "quiz.result_title"
        static let resultSubtitle = "quiz.result_subtitle"
        static let restart = "quiz.restart"
    }

    enum PromptStudio {
        static let title = "prompt_studio.title"
        static let roleLabel = "prompt_studio.role_label"
        static let roleHeader = "prompt_studio.role_header"
        static let roleFooter = "prompt_studio.role_footer"
        static let taskPlaceholder = "prompt_studio.task_placeholder"
        static let taskHeader = "prompt_studio.task_header"
        static let toneLabel = "prompt_studio.tone_label"
        static let toneHeader = "prompt_studio.tone_header"
        static let constraintsPlaceholder = "prompt_studio.constraints_placeholder"
        static let outputFormatLabel = "prompt_studio.output_format_label"
        static let extraHeader = "prompt_studio.extra_header"
        static let generate = "prompt_studio.generate"
        static let copyToClipboard = "prompt_studio.copy_to_clipboard"
        static let saveToLibrary = "prompt_studio.save_to_library"
        static let savedToLibrary = "prompt_studio.saved_to_library"
        static let preview = "prompt_studio.preview"
        static let copiedMessage = "prompt_studio.copied_message"
        static let historyTitle = "prompt_studio.history_title"
        static let noHistory = "prompt_studio.no_history"
        static let detailTitle = "prompt_studio.detail_title"
        static let taskDetail = "prompt_studio.task_detail"
        static let generatedPrompt = "prompt_studio.generated_prompt"
        static let roleTemplate = "prompt_studio.role_template"
        static let taskTemplate = "prompt_studio.task_template"
        static let toneTemplate = "prompt_studio.tone_template"
        static let constraintsTemplate = "prompt_studio.constraints_template"
        static let formatTemplate = "prompt_studio.format_template"
    }

    enum Scenario {
        static let viewMode = "scenario.view_mode"
        static let standard = "scenario.standard"
        static let quick = "scenario.quick"
        static let bookmarked = "scenario.bookmarked"
        static let saveTask = "scenario.save_task"
        static let openOutput = "scenario.open_output"
        static let quickSteps = "scenario.quick_steps"
        static let reset = "scenario.reset"
        static let starterTemplate = "scenario.starter_template"
        static let copyTemplate = "scenario.copy_template"
        static let exampleOutput = "scenario.example_output"
        static let steps = "scenario.steps"
        static let templates = "scenario.templates"
        static let pitfalls = "scenario.pitfalls"
        static let recommendedTools = "scenario.recommended_tools"
        static let reviewQuestions = "scenario.review_questions"
        static let reviewNotes = "scenario.review_notes"
        static let saveNote = "scenario.save_note"
    }

    enum Outcome {
        static let input = "outcome.input"
        static let audience = "outcome.audience"
        static let highlights = "outcome.highlights"
        static let metrics = "outcome.metrics"
        static let risks = "outcome.risks"
        static let nextPlan = "outcome.next_plan"
        static let promptsByFunction = "outcome.prompts_by_function"
        static let generalAssistant = "outcome.general_assistant"
        static let logicEnhanced = "outcome.logic_enhanced"
        static let creativeBoost = "outcome.creative_boost"
        static let deliverableTemplate = "outcome.deliverable_template"
        static let qualityChecklist = "outcome.quality_checklist"
        static let refinePrompt = "outcome.refine_prompt"
        static let exportPackage = "outcome.export_package"
        static let copyFullPackage = "outcome.copy_full_package"
        static let weeklyReportTitle = "outcome.weekly_report_title"
        static let weeklyReportEmpty = "outcome.weekly_report_empty"
        static let weeklyDefaultAudience = "outcome.weekly_default_audience"
        static let competitorTitle = "outcome.competitor_title"
        static let productA = "outcome.product_a"
        static let productB = "outcome.product_b"
        static let timeRange = "outcome.time_range"
        static let focus = "outcome.focus"
        static let competitorEmpty = "outcome.competitor_empty"
        static let competitorDefaultWindow = "outcome.competitor_default_window"
        static let competitorDefaultFocus = "outcome.competitor_default_focus"
        static let competitorDefaultAudience = "outcome.competitor_default_audience"
        static let prompt = "outcome.prompt"
        static let debugTitle = "outcome.debug_title"
        static let language = "outcome.language"
        static let expectedBehavior = "outcome.expected_behavior"
        static let errorLog = "outcome.error_log"
        static let codeSnippet = "outcome.code_snippet"
        static let debugEmpty = "outcome.debug_empty"
    }

    enum Stats {
        static let radarTitle = "stats.radar_title"
        static let trendTitle = "stats.trend_title"
    }

    enum ExportCard {
        static let highlights = "export_card.highlights"
        static let accessInfo = "export_card.access_info"
        static let suggestedPrompt = "export_card.suggested_prompt"
        static let note = "export_card.note"
        static let footerTitle = "export_card.footer_title"
        static let footerSubtitle = "export_card.footer_subtitle"
        static let qrTitle = "export_card.qr_title"
        static let qrSubtitle = "export_card.qr_subtitle"
        static let account = "export_card.account"
    }
}
