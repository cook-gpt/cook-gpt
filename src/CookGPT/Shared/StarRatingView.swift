//  StarRatingView.swift
//  CookGPT
//
//  Star rating display, picker, and rating sheet for recipes.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Int?
    var maxRating: Int = 5
    var starSize: CGFloat = 12
    var spacing: CGFloat = 2

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                    .font(.system(size: starSize))
                    .foregroundStyle(star <= (rating ?? 0) ? .yellow : .secondary.opacity(0.45))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ratingAccessibilityLabel)
    }

    private var ratingAccessibilityLabel: String {
        guard let rating else {
            return String(localized: "No rating")
        }
        return String(format: String(localized: "%lld star rating"), rating)
    }
}

private enum RecipeRatingPickerValue: Hashable {
    case none
    case rated(Int)

    var rating: Int? {
        switch self {
        case .none: nil
        case .rated(let value): value
        }
    }

    static func from(rating: Int?) -> RecipeRatingPickerValue {
        guard let rating else { return .none }
        return .rated(rating)
    }
}

private struct StarRatingPickerRowLabel: View {
    let filledStars: Int

    var body: some View {
        // Menu-style pickers flatten complex HStacks; a single Text row is reliable.
        Text(String(repeating: "★", count: filledStars))
            .font(.body)
            .foregroundStyle(.yellow)
            .accessibilityLabel(
                String(format: String(localized: "%lld star rating"), filledStars)
            )
    }
}

struct RecipeRatingPicker: View {
    @Binding var rating: Int?

    var body: some View {
        Picker("Rating", selection: selectionBinding) {
            Text("No rating").tag(RecipeRatingPickerValue.none)
            ForEach(1...5, id: \.self) { value in
                StarRatingPickerRowLabel(filledStars: value)
                    .tag(RecipeRatingPickerValue.rated(value))
            }
        }
    }

    private var selectionBinding: Binding<RecipeRatingPickerValue> {
        Binding(
            get: { RecipeRatingPickerValue.from(rating: rating) },
            set: { rating = $0.rating }
        )
    }
}

struct InteractiveStarRatingPicker: View {
    enum Layout {
        case standard
        case compact
    }

    @Binding var rating: Int?
    var allowsClear: Bool = true
    var layout: Layout = .standard

    private var starSize: CGFloat {
        layout == .compact ? 16 : 28
    }

    private var spacing: CGFloat {
        layout == .compact ? 3 : 10
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    if allowsClear, rating == star {
                        rating = nil
                    } else {
                        rating = star
                    }
                } label: {
                    Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                        .font(.system(size: starSize))
                        .foregroundStyle(.yellow)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(String(format: String(localized: "%lld stars"), star))
            }
        }
        .frame(
            minWidth: layout == .compact ? 112 : nil,
            maxWidth: layout == .compact ? 148 : nil,
            alignment: .trailing
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(String(localized: "Rating"))
    }
}

struct RecipeRatingSheet: View {
    let recipeTitle: String
    let initialRating: Int?
    let onSave: (Int?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedRating: Int?

    init(
        recipeTitle: String,
        initialRating: Int?,
        onSave: @escaping (Int?) -> Void
    ) {
        self.recipeTitle = recipeTitle
        self.initialRating = initialRating
        self.onSave = onSave
        _selectedRating = State(initialValue: initialRating)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text(recipeTitle)
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Text("Tap a star to rate this recipe.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)

                InteractiveStarRatingPicker(
                    rating: $selectedRating,
                    allowsClear: true,
                    layout: .standard
                )
                .scaleEffect(1.4)

                if selectedRating != nil {
                    Button("Clear rating", role: .destructive) {
                        selectedRating = nil
                    }
                    .font(.subheadline)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .navigationTitle("Rating")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel(String(localized: "Cancel"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave(selectedRating)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .accessibilityLabel(String(localized: "Done"))
                }
            }
        }
        .presentationDetents([.medium])
    }
}
