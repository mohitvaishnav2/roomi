import SwiftUI

// MARK: - Room Scanner View
struct RoomScannerView: View {

    @State private var phase: ScanPhase = .idle
    @State private var progress: CGFloat = 0
    @State private var tipIndex  = 0
    @State private var scanTimer: Timer?

    private let tips = [
        "Move slowly around the room",
        "Keep camera at chest height",
        "Ensure good lighting in the space",
        "Cover all four walls for best results"
    ]

    enum ScanPhase { case idle, scanning, done }

    // MARK: Body
    var body: some View {
        ZStack {
            darkBackground
            switch phase {
            case .idle:    idleView
            case .scanning: scanningView
            case .done:    doneView
            }
        }
        .ignoresSafeArea()
        .onDisappear { scanTimer?.invalidate() }
    }

    private var darkBackground: some View {
        LinearGradient(
            colors: [Color(hex: "#2A1F1C"), Color(hex: "#16100E")],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Idle View
    private var idleView: some View {
        VStack(spacing: 0) {
            scanTopBar(title: "Room Scanner") { }

            Spacer()

            // Viewfinder
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    .frame(width: 270, height: 350)

                // Corner markers
                ForEach(0..<4, id: \.self) { i in
                    CornerBracket()
                        .rotationEffect(.degrees(Double(i) * 90))
                        .frame(width: 270, height: 350)
                }

                VStack(spacing: 12) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 52, weight: .ultraLight))
                        .foregroundColor(AppTheme.Colors.primaryFixed.opacity(0.9))
                    Text("Point at your room")
                        .font(.custom("PlusJakartaSans-Medium", size: 15))
                        .foregroundColor(Color.white.opacity(0.65))
                }
            }

            Spacer()

            // Tip banner
            HStack(spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.Colors.primaryFixed)
                Text(tips[tipIndex])
                    .font(.custom("PlusJakartaSans-Regular", size: 13))
                    .foregroundColor(Color.white.opacity(0.75))
                Spacer()
            }
            .padding(14)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 24)
            .onAppear { startTipCycle() }

            // Scan FAB
            Button { startScan() } label: {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 72, height: 72)
                        .shadow(color: AppTheme.Colors.primary.opacity(0.55), radius: 22, y: 8)
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 32)
            .padding(.bottom, 60)
        }
        .padding(.top, 56)
    }

    // MARK: - Scanning View
    private var scanningView: some View {
        VStack(spacing: 0) {
            scanTopBar(title: "Scanning…") { stopScan() }

            Spacer()

            // Radial progress ring
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 3)
                    .frame(width: 220, height: 220)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [AppTheme.Colors.primaryFixed.opacity(0.4), AppTheme.Colors.primaryFixed]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.08), value: progress)

                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.custom("Quicksand-Bold", size: 52))
                        .foregroundColor(.white)
                    Text("Scanning Room")
                        .font(.custom("PlusJakartaSans-Medium", size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                }
            }

            Spacer()

            // Step checklist
            VStack(spacing: 14) {
                scanStep("Detected walls",       done: progress > 0.33)
                scanStep("Measuring dimensions", done: progress > 0.66)
                scanStep("Building 3D model",    done: progress > 0.92)
            }
            .padding(20)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
        }
        .padding(.top, 56)
    }

    // MARK: - Done View
    private var doneView: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryContainer.opacity(0.15))
                    .frame(width: 120, height: 120)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(AppTheme.Colors.primaryFixed)
            }

            VStack(spacing: 8) {
                Text("Scan Complete!")
                    .font(.custom("Quicksand-SemiBold", size: 28))
                    .foregroundColor(.white)
                Text("Your room has been captured.\nGenerating 3D model…")
                    .font(.custom("PlusJakartaSans-Regular", size: 15))
                    .foregroundColor(Color.white.opacity(0.65))
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 14) {
                Button(action: {}) {
                    Text("View 3D Model")
                        .font(.custom("PlusJakartaSans-SemiBold", size: 15))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)

                Button { withAnimation(.easeInOut) { phase = .idle; progress = 0 } } label: {
                    Text("Scan Again")
                        .font(.custom("PlusJakartaSans-Medium", size: 15))
                        .foregroundColor(Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
        }
    }

    // MARK: - Helpers
    private func scanTopBar(title: String, onClose: @escaping () -> Void) -> some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(title)
                .font(.custom("Quicksand-SemiBold", size: 20))
                .foregroundColor(.white)

            Spacer()

            Button(action: {}) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.white.opacity(0.65))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }

    private func scanStep(_ label: String, done: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 18))
                .foregroundColor(done ? AppTheme.Colors.primaryFixed : Color.white.opacity(0.25))
            Text(label)
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(done ? .white : Color.white.opacity(0.35))
            Spacer()
        }
    }

    private func startScan() {
        progress = 0
        withAnimation(.easeInOut(duration: 0.2)) { phase = .scanning }
        scanTimer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { t in
            if progress < 1.0 {
                progress += 0.008
            } else {
                t.invalidate()
                withAnimation(.spring(response: 0.5)) { phase = .done }
            }
        }
    }

    private func stopScan() {
        scanTimer?.invalidate()
        withAnimation(.easeInOut) { phase = .idle; progress = 0 }
    }

    private func startTipCycle() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.4)) {
                tipIndex = (tipIndex + 1) % tips.count
            }
        }
    }
}

// MARK: - Corner Bracket shape
struct CornerBracket: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Path { p in
                p.move(to: CGPoint(x: 0, y: 28))
                p.addLine(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: 28, y: 0))
            }
            .stroke(AppTheme.Colors.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .frame(width: w, height: h)
        }
    }
}

#Preview {
    RoomScannerView()
}
