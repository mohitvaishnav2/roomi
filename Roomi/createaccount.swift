import SwiftUI

// MARK: - Create Account Screen
struct CreateAccountView: View {

    @EnvironmentObject var auth: AuthManager
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var fullName        = ""
    @State private var email           = ""
    @State private var mobile          = ""
    @State private var dateOfBirth     = ""
    @State private var password        = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible  = false
    @State private var isConfirmVisible   = false
    @State private var localError: String?

    var body: some View {
        ZStack {
            // Background
            Color(hex: "#FAF5F2").ignoresSafeArea()

            // Card container
            VStack(spacing: 0) {
                // ── Header ──────────────────────────────────────────────────
                headerBar

                // ── Scrollable form ─────────────────────────────────────────
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        formBody

                        // ── Error Banner ──────────────────────────────────
                        let errorText = localError ?? auth.errorMessage
                        if let err = errorText {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(err)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .padding(.top, 16)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        termsSection
                        signUpButton
                        orDivider
                        googleButton
                        alreadyHaveAccount
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                    .animation(.easeInOut(duration: 0.2), value: localError ?? auth.errorMessage)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
            .padding(.horizontal, 0)
            .shadow(color: .black.opacity(0.12), radius: 30, x: 0, y: 10)
            .padding(.horizontal, 0)
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header bar
    private var headerBar: some View {
        ZStack {
            Text("Create Account")
                .font(.custom("Quicksand", size: 20).weight(.bold))
                .foregroundColor(AppTheme.Colors.peach)
                .frame(maxWidth: .infinity)

            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    // MARK: - Form body
    private var formBody: some View {
        VStack(spacing: 16) {
            inputField(label: "Full Name",   placeholder: "Example@Example.Com",
                       text: $fullName, keyboardType: .default)

            inputField(label: "Email",       placeholder: "Example@Example.Com",
                       text: $email, keyboardType: .emailAddress)

            inputField(label: "Mobile Number", placeholder: "+ 123 456 789",
                       text: $mobile, keyboardType: .phonePad)

            inputField(label: "Date Of Birth", placeholder: "DD / MM / YYYY",
                       text: $dateOfBirth, keyboardType: .default)

            // Password
            VStack(alignment: .leading, spacing: 6) {
                fieldLabel("Password")
                passwordField(text: $password, isVisible: $isPasswordVisible)
            }

            // Confirm Password
            VStack(alignment: .leading, spacing: 6) {
                fieldLabel("Confirm Password")
                passwordField(text: $confirmPassword, isVisible: $isConfirmVisible)
            }
        }
    }

    // MARK: - Generic text field
    @ViewBuilder
    private func inputField(label: String, placeholder: String,
                             text: Binding<String>,
                             keyboardType: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            fieldLabel(label)
            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#333333"))
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color(hex: "#FAEFEC"))
                .clipShape(Capsule())
        }
    }

    // MARK: - Password field
    @ViewBuilder
    private func passwordField(text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        HStack {
            Group {
                if isVisible.wrappedValue {
                    TextField("••••••••", text: text)
                } else {
                    SecureField("••••••••", text: text)
                }
            }
            .font(.system(size: 16, weight: .heavy))
            .foregroundColor(AppTheme.Colors.peach.opacity(0.5))
            .tracking(4)

            Spacer()

            Button(action: { isVisible.wrappedValue.toggle() }) {
                Image(systemName: isVisible.wrappedValue ? "eye" : "eye.slash")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.peach.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: "#FAEFEC"))
        .clipShape(Capsule())
    }

    // MARK: - Field label
    @ViewBuilder
    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(Color(hex: "#333333"))
            .padding(.leading, 4)
    }

    // MARK: - Terms
    private var termsSection: some View {
        VStack(spacing: 2) {
            Text("By continuing, you agree to")
            HStack(spacing: 4) {
                Text("Terms of Use")
                    .fontWeight(.bold)
                Text("and")
                    .foregroundColor(Color(hex: "#888888"))
                Text("Privacy Policy.")
                    .fontWeight(.bold)
            }
        }
        .font(.system(size: 11))
        .foregroundColor(Color(hex: "#333333"))
        .multilineTextAlignment(.center)
        .padding(.top, 28)
        .padding(.bottom, 20)
    }

    // MARK: - Sign Up CTA
    private var signUpButton: some View {
        Button(action: {
            localError = nil
            auth.errorMessage = nil
            guard password == confirmPassword else {
                localError = "Passwords don't match."
                return
            }
            Task { await auth.signUp(email: email, password: password, fullName: fullName) }
        }) {
            ZStack {
                Text("Sign Up")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(auth.isLoading ? 0 : 1)

                if auth.isLoading {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.Colors.peach)
            .clipShape(Capsule())
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(auth.isLoading)
    }

    // MARK: - OR divider
    private var orDivider: some View {
        HStack {
            Rectangle().fill(Color(.systemGray5)).frame(height: 1)
            Text("or sign up with")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "#888888"))
                .fixedSize()
            Rectangle().fill(Color(.systemGray5)).frame(height: 1)
        }
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    // MARK: - Google SSO
    private var googleButton: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                ZStack {
                    Circle()
                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                        .frame(width: 44, height: 44)
                    GoogleLogoShape()
                        .fill(
                            LinearGradient(colors: [
                                Color(hex: "#4285F4"),
                                Color(hex: "#34A853"),
                                Color(hex: "#FBBC05"),
                                Color(hex: "#EA4335")
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 20, height: 20)
                }
            }
            Spacer()
        }
    }

    // MARK: - Already have account
    private var alreadyHaveAccount: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "#333333"))

            Button(action: { dismiss() }) {
                Text("Log in")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.peach)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
}

// MARK: - Google "G" logo shape (simple SVG-path approximation)
struct GoogleLogoShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Simplified G shape using the four colour paths
        let cx = rect.midX, cy = rect.midY
        let r  = min(rect.width, rect.height) / 2

        var p = Path()
        // Outer circle approximation
        p.addArc(center: CGPoint(x: cx, y: cy), radius: r,
                 startAngle: .degrees(-10), endAngle: .degrees(180), clockwise: false)
        p.addArc(center: CGPoint(x: cx, y: cy), radius: r * 0.55,
                 startAngle: .degrees(180), endAngle: .degrees(-10), clockwise: true)
        // Right stub for the "G"
        p.addRect(CGRect(x: cx, y: cy - r * 0.12, width: r, height: r * 0.24))
        return p
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
            .environmentObject(AuthManager())
    }
}
