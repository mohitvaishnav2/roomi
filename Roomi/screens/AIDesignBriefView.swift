import SwiftUI

// MARK: - AI Design Brief View (Screen 13)
struct AIDesignBriefView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selectedStyles: Set<DesignStyle> = []
    @State private var selectedMood: String? = nil
    @State private var budget: Double = 2000
    @State private var priorityFeature: String? = nil
    @State private var additionalNotes = ""
    @FocusState private var isNotesFocused: Bool

    private let moods = ["Cozy & Warm", "Airy & Light", "Bold & Dramatic", "Calm & Serene", "Playful & Eclectic"]
    private let priorities = ["Comfort", "Storage", "Work Space", "Entertainment", "Aesthetics"]

    private var isReadyToGenerate: Bool {
        !selectedStyles.isEmpty && selectedMood != nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Style Picker
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Design Style", subtitle: "Choose up to 3 styles")

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                        spacing: 10
                    ) {
                        ForEach(DesignStyle.allCases) { style in
                            StyleCard(
                                style: style,
                                isSelected: selectedStyles.contains(style)
                            ) {
                                withAnimation(.interactiveSpring()) {
                                    if selectedStyles.contains(style) {
                                        selectedStyles.remove(style)
                                    } else if selectedStyles.count < 3 {
                                        selectedStyles.insert(style)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)

                // Mood
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Room Mood")
                        .padding(.horizontal, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(moods, id: \.self) { mood in
                                Button {
                                    withAnimation { selectedMood = selectedMood == mood ? nil : mood }
                                } label: {
                                    Text(mood)
                                        .font(AppTheme.Typography.labelMd)
                                        .foregroundStyle(selectedMood == mood ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        .background(
                                            selectedMood == mood
                                            ? AppTheme.Colors.primaryContainer
                                            : AppTheme.Colors.surfaceContainer
                                        )
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                // Budget
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(
                        title: "Budget",
                        subtitle: "$\(Int(budget).formatted()) total"
                    )
                    .padding(.horizontal, 16)

                    Slider(value: $budget, in: 500...20000, step: 500)
                        .tint(AppTheme.Colors.primary)
                        .padding(.horizontal, 24)

                    HStack {
                        Text("$500").font(AppTheme.Typography.labelSm).foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        Spacer()
                        Text("$20,000").font(AppTheme.Typography.labelSm).foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    .padding(.horizontal, 24)
                }

                // Priority Feature
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Top Priority")
                        .padding(.horizontal, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(priorities, id: \.self) { p in
                                Button {
                                    withAnimation { priorityFeature = priorityFeature == p ? nil : p }
                                } label: {
                                    Text(p)
                                        .font(AppTheme.Typography.labelMd)
                                        .foregroundStyle(priorityFeature == p ? AppTheme.Colors.primary : AppTheme.Colors.onSurfaceVariant)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        .background(
                                            priorityFeature == p
                                            ? AppTheme.Colors.primaryContainer
                                            : AppTheme.Colors.surfaceContainer
                                        )
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                // Notes
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Notes")
                        .font(AppTheme.Typography.labelMd)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        .padding(.horizontal, 16)

                    TextEditor(text: $additionalNotes)
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .focused($isNotesFocused)
                        .frame(minHeight: 100)
                        .padding(14)
                        .background(AppTheme.Colors.surfaceContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                        .padding(.horizontal, 16)
                }

                // Generate
                VStack(spacing: 8) {
                    PrimaryButton("Generate AI Design", icon: "sparkles", isLoading: false) {
                        router.push(.aiProcessing)
                    }
                    .disabled(!isReadyToGenerate)
                    .opacity(isReadyToGenerate ? 1.0 : 0.5)

                    if !isReadyToGenerate {
                        Text("Select at least one style and a mood to continue")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .padding(.top, 8)
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Design Brief")
        .navigationBarTitleDisplayMode(.large)
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    NavigationStack {
        AIDesignBriefView()
            .environment(NavigationRouter())
    }
}
