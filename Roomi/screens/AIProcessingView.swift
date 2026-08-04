import SwiftUI

// MARK: - AI Processing View (Screen 14)
struct AIProcessingView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var activeStep = 0
    @State private var orbScale: CGFloat = 1.0
    @State private var orbOpacity: Double = 0.6
    @State private var ringRotation: Double = 0
    @State private var isComplete = false

    private let steps = [
        "Analysing spatial model",
        "Matching design styles",
        "Generating furniture layout",
        "Applying colour palette",
        "Rendering design concepts",
        "Finalising AI recommendations",
    ]

    var body: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Animated Orb
                ZStack {
                    // Background rings
                    ForEach([200.0, 160.0, 120.0], id: \.self) { size in
                        Circle()
                            .stroke(AppTheme.Colors.primary.opacity(0.06), lineWidth: 1)
                            .frame(width: size, height: size)
                            .scaleEffect(orbScale)
                    }

                    // Rotating ring
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [AppTheme.Colors.primary.opacity(0), AppTheme.Colors.primary]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(ringRotation))

                    // Core orb
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppTheme.Colors.primaryContainer, AppTheme.Colors.primary.opacity(0.3)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 44
                            )
                        )
                        .frame(width: 88, height: 88)
                        .scaleEffect(orbScale)
                        .opacity(orbOpacity)

                    Image(systemName: isComplete ? "checkmark" : "sparkles")
                        .font(.system(size: 32, weight: isComplete ? .bold : .light))
                        .foregroundStyle(AppTheme.Colors.primary)
                        .contentTransition(.symbolEffect(.replace))
                        .animation(.spring(response: 0.5), value: isComplete)
                }

                // Status Text
                VStack(spacing: 10) {
                    Text(isComplete ? "Design Ready!" : "Creating Your Design")
                        .font(AppTheme.Typography.headlineLgMobile)
                        .foregroundStyle(AppTheme.Colors.onSurface)
                        .contentTransition(.opacity)
                        .animation(.easeInOut, value: isComplete)

                    Text(isComplete
                         ? "Your personalised room concepts are ready to explore."
                         : "RoomIQ AI is working its magic…"
                    )
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                }

                // Step Progress
                VStack(spacing: 8) {
                    ForEach(steps.indices, id: \.self) { idx in
                        AIProcessingCard(
                            step: steps[idx],
                            isActive: activeStep == idx,
                            isComplete: idx < activeStep
                        )
                    }
                }
                .padding(.horizontal, 24)

                // Overall Progress Bar
                if !isComplete {
                    VStack(spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(AppTheme.Colors.surfaceContainer).frame(height: 6)
                                Capsule()
                                    .fill(AppTheme.Colors.primary)
                                    .frame(
                                        width: geo.size.width * Double(activeStep) / Double(steps.count),
                                        height: 6
                                    )
                                    .animation(.easeInOut(duration: 0.4), value: activeStep)
                            }
                        }
                        .frame(height: 6)
                        Text("\(Int(Double(activeStep) / Double(steps.count) * 100))%")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                if isComplete {
                    PrimaryButton("View Design Results", icon: "arrow.right") {
                        router.push(.aiResult)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { startProcessing() }
    }

    private func startProcessing() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            ringRotation = 360
        }
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            orbScale = 1.08
            orbOpacity = 1.0
        }

        Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { timer in
            withAnimation {
                if activeStep < steps.count - 1 {
                    activeStep += 1
                } else {
                    timer.invalidate()
                    withAnimation(.spring(response: 0.5)) { isComplete = true }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AIProcessingView()
            .environment(NavigationRouter())
    }
}
