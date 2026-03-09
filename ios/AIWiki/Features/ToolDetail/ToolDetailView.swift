import SwiftUI
import UIKit

struct ToolDetailView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.colorScheme) var colorScheme

    let tool: AITool
    @State private var copied = false
    @State private var showingShareSheet = false
    @State private var showingNoteEditor = false
    @State private var noteText = ""
    @State private var showingExportPreview = false
    @State private var showingConsole = false
    @Environment(\.dismiss) private var dismiss
    @State private var exportedImage: UIImage?
    @State private var hasCheckedIn = false
    @State private var isGeneratingImage = false
    private var websiteURL: URL? { URL(string: tool.url) }
    private var learningMaterial: LearningMaterial? { store.learningMaterial(for: tool.id) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(spacing: 14) {
                    ToolAvatar(name: tool.name, size: 80)

                    Text(tool.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)

                    Text(tool.company)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)

                    // Favorite button
                    Button {
                        store.toggleFavorite(tool.id)
                    } label: {
                        Label(
                            store.isFavorite(tool.id) ? L10n.text(L10n.Detail.favorited) : L10n.text(L10n.Detail.favorite),
                            systemImage: store.isFavorite(tool.id) ? "heart.fill" : "heart"
                        )
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(store.isFavorite(tool.id) ? .white : AppColors.accent)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(store.isFavorite(tool.id) ? AppColors.accent : AppColors.card)
                        )
                        .overlay(
                            Capsule()
                                .stroke(AppColors.accent.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)

                // MARK: - Intro
                detailSection(L10n.text(L10n.Detail.intro)) {
                    Text(tool.localizedIntro)
                        .font(.body)
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // MARK: - Features
                detailSection(L10n.text(L10n.Detail.features)) {
                    FlowLayout(spacing: 8) {
                        ForEach(tool.localizedFeatures, id: \.self) { feature in
                            Text(feature)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.accentLight)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(AppColors.accent.opacity(0.15))
                                )
                        }
                    }
                }

                // MARK: - Learning Material
                if let learningMaterial {
                    detailSection(L10n.text(L10n.Detail.learningSummary)) {
                        Text(learningMaterial.localizedSummary)
                            .font(.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    if !learningMaterial.localizedCoreCapabilities.isEmpty {
                        detailSection(L10n.text(L10n.Detail.coreCapabilities)) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(learningMaterial.localizedCoreCapabilities, id: \.self) { item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppColors.accent)
                                            .font(.caption)
                                        Text(item)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                }
                            }
                        }
                    }

                    if !learningMaterial.localizedGettingStarted.isEmpty {
                        detailSection(L10n.text(L10n.Detail.gettingStarted)) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(learningMaterial.localizedGettingStarted.enumerated()), id: \.offset) { index, item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("\(index + 1)")
                                            .font(.caption.weight(.bold))
                                            .foregroundColor(AppColors.accent)
                                            .frame(width: 20, height: 20)
                                            .background(Circle().fill(AppColors.accent.opacity(0.15)))
                                        Text(item)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                }
                            }
                        }
                    }

                    if !learningMaterial.officialLinks.isEmpty {
                        detailSection(L10n.text(L10n.Detail.officialLinks)) {
                            VStack(alignment: .leading, spacing: 6) {
                                // Deduplicate links to prevent repeating content if data is not clean
                                let uniqueLinks = Array(Set(learningMaterial.officialLinks)).sorted()
                                ForEach(uniqueLinks, id: \.self) { link in
                                     if let url = URL(string: link) {
                                         Link(link, destination: url)
                                             .font(.footnote)
                                             .foregroundColor(AppColors.accentLight)
                                             .lineLimit(2)
                                     }
                                }
                            }
                        }
                    }

                    if !learningMaterial.localizedCaveats.isEmpty {
                        detailSection(L10n.text(L10n.Detail.caveats)) {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(learningMaterial.localizedCaveats, id: \.self) { item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption2)
                                        Text(item)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                }
                            }
                        }
                    }
                }

                // MARK: - Use Cases
                if let useCases = tool.localizedUseCases, !useCases.isEmpty {
                    detailSection(L10n.text(L10n.Detail.useCases)) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(useCases, id: \.self) { item in
                                bulletRow(item)
                            }
                        }
                    }
                }

                // MARK: - Best Practices
                if let bestPractices = tool.localizedBestPractices, !bestPractices.isEmpty {
                    detailSection(L10n.text(L10n.Detail.bestPractices)) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(bestPractices, id: \.self) { item in
                                bulletRow(item)
                            }
                        }
                    }
                }

                // MARK: - Prompt Templates
                if !tool.localizedPromptTemplates.isEmpty {
                    detailSection(L10n.text(L10n.Detail.promptTemplates)) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(tool.localizedPromptTemplates, id: \.title) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(AppColors.textPrimary)
                                    Text(item.prompt)
                                        .font(.footnote)
                                        .foregroundColor(AppColors.textSecondary)
                                        .textSelection(.enabled)
                                }
                            }
                        }
                    }
                }

                // MARK: - Strengths & Limitations
                if let strengths = tool.localizedStrengths, !strengths.isEmpty {
                    detailSection(L10n.text(L10n.Detail.strengths)) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(strengths, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text(item)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                        }
                    }
                }

                if let limitations = tool.localizedLimitations, !limitations.isEmpty {
                    detailSection(L10n.text(L10n.Detail.limitations)) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(limitations, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    Text(item)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                        }
                    }
                }
                
                detailSection(L10n.text(L10n.Detail.radar)) {
                    RadarChartView(scoresA: tool.radarScoresOrDefault, scoresB: nil)
                        .padding(.vertical, -40)
                }

                // MARK: - My Rating & Notes
                detailSection(L10n.text(L10n.Detail.myRating)) {
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    store.rate(toolID: tool.id, score: star)
                                }
                            } label: {
                                Image(systemName: star <= store.rating(for: tool.id) ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(star <= store.rating(for: tool.id) ? .yellow : AppColors.textSecondary.opacity(0.4))
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer()
                        if store.rating(for: tool.id) > 0 {
                            Button {
                                store.rate(toolID: tool.id, score: 0)
                            } label: {
                                Text(L10n.text(L10n.Common.clear))
                                    .font(.caption)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                detailSection(L10n.text(L10n.Detail.notes)) {
                    VStack(alignment: .leading, spacing: 10) {
                        let existingNote = store.toolNote(for: tool.id)
                        if !showingNoteEditor && !existingNote.isEmpty {
                            Text(existingNote)
                                .font(.subheadline)
                                .foregroundColor(AppColors.textPrimary)
                        }

                        if showingNoteEditor {
                            TextEditor(text: $noteText)
                                .frame(minHeight: 80)
                                .font(.subheadline)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AppColors.cardHighlight)
                                )

                            HStack {
                                Button(L10n.text(L10n.Common.cancel)) {
                                    showingNoteEditor = false
                                    noteText = store.toolNote(for: tool.id)
                                }
                                .foregroundColor(AppColors.textSecondary)
                                Spacer()
                                Button(L10n.text(L10n.Common.save)) {
                                    store.updateToolNote(toolID: tool.id, text: noteText)
                                    showingNoteEditor = false
                                }
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.accent)
                            }
                            .font(.subheadline)
                        } else {
                            Button {
                                noteText = store.toolNote(for: tool.id)
                                showingNoteEditor = true
                            } label: {
                                Label(existingNote.isEmpty ? L10n.text(L10n.Detail.notePlaceholder) : L10n.text(L10n.Detail.editNote),
                                      systemImage: existingNote.isEmpty ? "square.and.pencil" : "pencil")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.accent)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // MARK: - Info & Actions
                detailSection(L10n.text(L10n.Detail.basicInfo)) {
                    VStack(alignment: .leading, spacing: 10) {
                        infoRow(label: L10n.text(L10n.Common.company), value: tool.company)
                        infoRow(label: L10n.text(L10n.Common.category), value: tool.localizedCategory)

                        if let access = tool.access {
                            infoRow(label: L10n.text(L10n.Common.pricing), value: tool.localizedAccessPricing ?? access.pricing)
                            infoRow(label: L10n.text(L10n.Detail.accountRequired), value: access.accountRequired ? L10n.text(L10n.Common.yes) : L10n.text(L10n.Common.no))
                            infoRow(label: L10n.text(L10n.Common.platform), value: (tool.localizedAccessPlatforms ?? access.platforms).joined(separator: " / "))
                            infoRow(label: L10n.text(L10n.Common.api), value: access.apiAvailable ? L10n.text(L10n.Common.yes) : L10n.text(L10n.Common.no))
                        }
                    }
                }

                // Action buttons
                VStack(spacing: 10) {
                    if websiteURL != nil {
                        Button {
                            showingConsole = true
                        } label: {
                            HStack {
                                Image(systemName: "safari.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text(L10n.text(L10n.Detail.openNow))
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(AppGradients.accent)
                            .cornerRadius(12)
                        }
                        .fullScreenCover(isPresented: $showingConsole) {
                            AIConsoleView(initialToolName: tool.name, initialURL: tool.url)
                        }
                    }

                    Button {
                        UIPasteboard.general.string = tool.url
                        copied = true
                    } label: {
                        HStack {
                            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            Text(copied ? L10n.text(L10n.Common.copied) : L10n.text(L10n.Detail.copyLink))
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(AppColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppColors.accent.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        generateExportImage()
                    } label: {
                        HStack {
                            if isGeneratingImage {
                                ProgressView()
                                    .tint(AppColors.accent)
                                    .padding(.trailing, 4)
                            } else {
                                Image(systemName: "photo.artframe")
                            }
                            Text(isGeneratingImage ? L10n.text(L10n.Detail.generating) : L10n.text(L10n.Detail.generateCard))
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(AppColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppColors.accent.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isGeneratingImage)

                    Button {
                        if !hasCheckedIn {
                            store.checkIn(tool: tool)
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            withAnimation {
                                hasCheckedIn = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    hasCheckedIn = false
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: hasCheckedIn ? "checkmark.circle.fill" : "calendar.badge.plus")
                            Text(hasCheckedIn ? L10n.text(L10n.Detail.checkedIn) : L10n.text(L10n.Detail.checkIn))
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(hasCheckedIn ? .white : AppColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(hasCheckedIn ? Color.green.opacity(0.8) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(hasCheckedIn ? Color.clear : AppColors.accent.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(AppColors.background.ignoresSafeArea())
        .background(
            // Warm-up hack: Put the export view in the real hierarchy (invisible)
            ToolCardExportView(
                tool: tool,
                note: store.toolNote(for: tool.id),
                rating: store.rating(for: tool.id)
            )
            .frame(width: 450, height: 800)
            .opacity(0)
            .allowsHitTesting(false)
        )
        .navigationTitle(L10n.text(L10n.Detail.title))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(AppColors.accent)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            let text = "\(L10n.text(L10n.Detail.sharePrefix))\(tool.name) — \(tool.localizedIntro) 👉 \(tool.url)"
            ShareSheet(items: [text])
        }
        .sheet(isPresented: $showingExportPreview) {
            if let exportedImage {
                ExportPreviewView(image: exportedImage)
            }
        }
    }

    // MARK: - Export Logic
    
    @MainActor
    private func generateExportImage() {
        isGeneratingImage = true
        let note = store.toolNote(for: tool.id)
        let rating = store.rating(for: tool.id)
        let exportView = ToolCardExportView(tool: tool, note: note, rating: rating)
            .environment(\.colorScheme, colorScheme)
        
        // Use a more robust UIHostingController method for first-time rendering
        let controller = UIHostingController(rootView: exportView)
        let view = controller.view
        
        // Set fixed dimensions for the redesigned card
        let targetSize = CGSize(width: 450, height: 800)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        Task {
            // Give extra time for layout and data to settle
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let image = renderer.image { _ in
                view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }
            
            self.exportedImage = image
            self.isGeneratingImage = false
            self.showingExportPreview = true
        }
    }

    // MARK: - Helpers

    private func detailSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }

    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            Text(text)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}
