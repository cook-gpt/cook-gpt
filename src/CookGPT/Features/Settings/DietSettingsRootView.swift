//  DietSettingsRootView.swift
//  CookGPT
//
//  Advanced diet management and global meal-planning rules.
//

import SwiftUI
import SwiftData

struct DietSettingsRootView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @Query(sort: \DietProfile.name) private var dietProfiles: [DietProfile]

    @State private var editorPresentation: DietEditorPresentation?

    private struct DietEditorPresentation: Identifiable {
        let id = UUID()
        let profile: DietProfile
        let isNew: Bool
    }

    var body: some View {
        List {
            Section {
                NavigationLink {
                    GeneralMealRulesView()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("General meal rules")
                        Text("Breakfast, lunch, dinner, and global forbidden categories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } footer: {
                Text("General rules apply to every diet. Use them for slot-wide rules such as requiring Breakfast tags in the morning or excluding desserts from all meals.")
            }

            Section {
                ForEach(dietProfiles, id: \.id) { profile in
                    NavigationLink {
                        DietEditorView(profile: profile, isNew: false)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(profile.name)
                                if profile.isActive {
                                    Text("Default")
                                        .font(.caption2.weight(.semibold))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.accentColor.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }

                            CategoryRulesSummaryRow(
                                mandatoryCategoryIDs: profile.mandatoryCategoryIDs,
                                forbiddenCategoryIDs: profile.forbiddenCategoryIDs,
                                emptyLabel: String(localized: "No general rules")
                            )
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        if !profile.isActive {
                            Button {
                                setDefaultProfile(profile)
                            } label: {
                                Label(String(localized: "Default"), systemImage: "checkmark.circle.fill")
                            }
                            .tint(.green)
                        }
                    }
                }
                .onDelete(perform: deleteProfiles)
            } header: {
                Text("Diets")
            } footer: {
                Text("Each diet adds mandatory and forbidden categories on top of the general meal rules. Enable meal-specific overrides to customize breakfast, lunch, or dinner—for example a low-carb dinner on a keto plan.")
            }
        }
        .navigationTitle("Diets")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    editorPresentation = DietEditorPresentation(
                        profile: DietProfile(name: ""),
                        isNew: true
                    )
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add diet")
            }
        }
        .sheet(item: $editorPresentation) { presentation in
            NavigationStack {
                DietEditorView(profile: presentation.profile, isNew: presentation.isNew)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                editorPresentation = nil
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .accessibilityLabel("Cancel")
                        }
                    }
            }
        }
    }

    private func setDefaultProfile(_ profile: DietProfile) {
        guard !profile.isActive else { return }

        for dietProfile in dietProfiles {
            dietProfile.isActive = dietProfile.id == profile.id
        }

        try? modelContext.save()
    }

    private func deleteProfiles(at offsets: IndexSet) {
        let profilesToDelete = offsets.map { dietProfiles[$0] }
        let deletingActive = profilesToDelete.contains { $0.isActive }

        for profile in profilesToDelete {
            modelContext.delete(profile)
        }

        try? modelContext.save()

        if deletingActive {
            let remaining = (try? modelContext.fetch(FetchDescriptor<DietProfile>())) ?? []
            if let replacement = remaining.first {
                replacement.isActive = true
                try? modelContext.save()
            } else {
                DietProfileSeeder.seedIfNeeded(context: modelContext)
            }
        }
    }
}
