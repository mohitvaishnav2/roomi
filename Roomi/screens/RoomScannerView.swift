import SwiftUI

// MARK: - Room Scanner View (Screen 11)
struct RoomScannerView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var scanPhase: ScanPhase = .ready
    @State private var progress: Double = 0
    @State private var ringRotation: Double = 0
    @State private var pulseOpacity: Double = 0.4
    @State private var scannedPoints: [CGPoint] = []

    enum ScanPhase: String {
        case ready = "Point at a corner to begin"
        case scanning = "Scanning room…"
        case processing = "Building 3D model…"
        case complete = "Scan complete!"
    }

    var body: some View {
        ZStack {
            // Simulated Camera View
            Color.black.ignoresSafeArea()

            // Grid Overlay
            Canvas { context, size in
                let gridSpacing: CGFloat = 40
                context.opacity = 0.08
                var x: CGFloat = 0
                while x < size.width {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                    context.stroke(path, with: .color(.green), lineWidth: 0.5)
                    x += gridSpacing
                }
                var y: CGFloat = 0
                while y < size.height {
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(path, with: .color(.green), lineWidth: 0.5)
                    y += gridSpacing
                }
            }
            .ignoresSafeArea()

            // Scan Points
            ForEach(scannedPoints.indices, id: \.self) { idx in
                Circle()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 6, height: 6)
                    .position(scannedPoints[idx])
                    .transition(.opacity.combined(with: .scale(scale: 0)))
            }

            // Center Reticle
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(pulseOpacity), lineWidth: 1)
                    .frame(width: 160, height: 160)
                    .scaleEffect(scanPhase == .scanning ? 1.1 : 1.0)

                // Rotating arc
                Circle()
                    .trim(from: 0, to: scanPhase == .scanning ? 0.3 : 0)
                    .stroke(
                        AngularGradient(colors: [.clear, AppTheme.Colors.primary], center: .center),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(ringRotation))

                // Corner markers
                ForEach([0, 90, 180, 270], id: \.self) { angle in
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 16, height: 3)
                        .offset(x: 62)
                        .rotationEffect(.degrees(Double(angle)))
                }

                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 24, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.6))
            }

            // Top HUD
            VStack {
                HStack {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    Spacer()

                    // Privacy Indicator
                    HStack(spacing: 6) {
                        Circle().fill(.green).frame(width: 7, height: 7)
                        Text("Camera Active")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(.ultraThinMaterial, in: Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer()

                // Phase Status + Progress
                VStack(spacing: 16) {
                    if scanPhase == .scanning || scanPhase == .processing {
                        // Progress bar
                        VStack(spacing: 6) {
                            HStack {
                                Text(scanPhase.rawValue)
                                    .font(AppTheme.Typography.labelMd)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(Int(progress * 100))%")
                                    .font(AppTheme.Typography.labelMd)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(.white.opacity(0.2)).frame(height: 4)
                                    Capsule()
                                        .fill(AppTheme.Colors.primary)
                                        .frame(width: geo.size.width * progress, height: 4)
                                        .animation(.easeInOut(duration: 0.3), value: progress)
                                }
                            }
                            .frame(height: 4)
                        }
                        .padding(.horizontal, 24)
                    }

                    // Action Button
                    Group {
                        switch scanPhase {
                        case .ready:
                            PrimaryButton("Begin Scan") {
                                startScan()
                            }
                        case .scanning:
                            OutlinedButton("Pause") {}
                        case .processing:
                            EmptyView()
                        case .complete:
                            PrimaryButton("Review Scan", icon: "checkmark") {
                                router.push(.scanReview)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
                .background(
                    LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden()
        .onAppear { startAnimations() }
    }

    private func startAnimations() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            ringRotation = 360
        }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseOpacity = 1.0
        }
    }

    private func startScan() {
        scanPhase = .scanning
        // Simulate scanning progress
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            progress += 0.012
            if Int.random(in: 0...5) == 0 {
                let x = CGFloat.random(in: 60...320)
                let y = CGFloat.random(in: 150...600)
                withAnimation { scannedPoints.append(CGPoint(x: x, y: y)) }
            }
            if progress >= 0.9 {
                timer.invalidate()
                scanPhase = .processing
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
                    progress += 0.01
                    if progress >= 1.0 {
                        t.invalidate()
                        progress = 1.0
                        withAnimation { scanPhase = .complete }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoomScannerView()
            .environment(NavigationRouter())
    }
}
