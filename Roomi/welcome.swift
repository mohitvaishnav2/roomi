import SwiftUI

// MARK: - Login / Welcome Screen
struct WelcomeView: View {

    @EnvironmentObject var auth: AuthManager
    @State private var email              = ""
    @State private var password           = ""
    @State private var isPasswordVisible  = false
    @State private var navigateToSignUp   = false
    @State private var showResetAlert     = false
    @State private var resetEmail         = ""

    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 0) {
                heroSection
                formCard
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToSignUp) {
            CreateAccountView()
        }
        .alert("Reset Password", isPresented: $showResetAlert) {
            TextField("Your email", text: $resetEmail)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            Button("Send Link") {
                Task { await auth.sendPasswordReset(email: resetEmail) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Enter your email and we'll send a reset link.")
        }
    }

    // MARK: - Hero Image
    private var heroSection: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuA58dUJ_BumaovU5HPByIunPOQzEBSy1_Nhx0YcsiuoUQMrCDc0abr03Bvp7QpTCRltdVVgURaOLteOn1wBoeTul6rLpHRdnOIZTJYXtrto6atc3abSvLzdxZZeVNXYCfjGIj4Hkn3rCyxr2zULtJsnH-aL3lFn3BrAvsnVCGeZat1rPcFlG9jUrI4roET5V8h8oCTt5hra2ak-WflexV3SN3N6RF6djkih8BdbxB1KH1GCDyCJAELzPA")) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                case .failure, .empty:
                    Rectangle().fill(AppTheme.Colors.primaryContainer)
                @unknown default:
                    Rectangle().fill(AppTheme.Colors.primaryContainer)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 360)
            .clipped()

            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 52)
            .padding(.leading, 24)
        }
        .frame(height: 360)
    }

    // MARK: - Form Card
    private var formCard: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("Welcome Back")
                    .font(.custom("Quicksand-SemiBold", size: 28))
                    .foregroundColor(AppTheme.Colors.secondary)

                Text("Log in to your curated sanctuary.")
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)
            }
            .padding(.top, 40)
            .padding(.bottom, 24)

            // ── Error Banner ───────────────────────────────────────────────
            if let error = auth.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(AppTheme.Typography.labelSm)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // ── Fields ────────────────────────────────────────────────────
            VStack(spacing: 24) {
                // Email
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(AppTheme.Typography.labelMd)
                        .foregroundColor(AppTheme.Colors.onSurface)
                        .padding(.leading, 4)

                    HStack(spacing: 12) {
                        Image(systemName: "envelope")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.Colors.onSurfaceVariant.opacity(0.7))
                            .frame(width: 20)

                        TextField("hello@example.com", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundColor(AppTheme.Colors.onSurface)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(AppTheme.Colors.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                // Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(AppTheme.Typography.labelMd)
                        .foregroundColor(AppTheme.Colors.onSurface)
                        .padding(.leading, 4)

                    HStack(spacing: 12) {
                        Image(systemName: "lock")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.Colors.onSurfaceVariant.opacity(0.7))
                            .frame(width: 20)

                        Group {
                            if isPasswordVisible {
                                TextField("••••••••", text: $password)
                            } else {
                                SecureField("••••••••", text: $password)
                            }
                        }
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundColor(AppTheme.Colors.onSurface)

                        Spacer()

                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .font(.system(size: 16))
                                .foregroundColor(AppTheme.Colors.onSurfaceVariant.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(AppTheme.Colors.surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    HStack {
                        Spacer()
                        Button(action: {
                            resetEmail = email
                            showResetAlert = true
                        }) {
                            Text("Forgot Password?")
                                .font(AppTheme.Typography.labelSm)
                                .foregroundColor(AppTheme.Colors.secondary)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 40)

            // ── Actions ───────────────────────────────────────────────────
            VStack(spacing: 24) {
                // Login CTA
                Button(action: {
                    Task { await auth.signIn(email: email, password: password) }
                }) {
                    ZStack {
                        HStack(spacing: 8) {
                            Text("Login")
                                .font(AppTheme.Typography.labelMd)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.Colors.onPrimaryContainer)
                        .opacity(auth.isLoading ? 0 : 1)

                        if auth.isLoading {
                            ProgressView()
                                .tint(AppTheme.Colors.onPrimaryContainer)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(AppTheme.Colors.primaryContainer)
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: "#8C634F").opacity(0.10), radius: 20, x: 0, y: 8)
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(auth.isLoading)

                // Sign up link
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(AppTheme.Typography.bodyMd)
                        .foregroundColor(AppTheme.Colors.onSurfaceVariant)

                    Button(action: { navigateToSignUp = true }) {
                        Text("Sign up instead")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundColor(AppTheme.Colors.secondary)
                            .underline(true, color: AppTheme.Colors.secondary.opacity(0.4))
                    }
                }
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .background(AppTheme.Colors.surfaceContainerLowest)
        .clipShape(RoundedCornerShape(radius: 32, corners: [.topLeft, .topRight]))
        .offset(y: -40)
        .shadow(color: Color(hex: "#8C634F").opacity(0.05), radius: 40, x: 0, y: -10)
        .animation(.easeInOut(duration: 0.2), value: auth.errorMessage)
    }
}

// MARK: - Helpers

/// Clips only specific corners
struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

/// Scale press animation for buttons
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            .environmentObject(AuthManager())
    }
}
