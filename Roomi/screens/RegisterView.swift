import SwiftUI

// MARK: - Register View (Screen 06)
struct RegisterView: View {
    let onBack: () -> Void

    @EnvironmentObject private var auth: AuthManager
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmVisible = false
    @State private var agreedToTerms = false
    @FocusState private var focusedField: Field?

    private enum Field { case name, email, password, confirm }

    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && password.count >= 8
            && password == confirmPassword && agreedToTerms
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [Color(hex: "#DBE1C0"), Color(hex: "#C4CAA9"), AppTheme.Colors.surfaceContainerHigh],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Create account")
                            .font(AppTheme.Typography.displayLg)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Text("Start your design journey")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    .padding(28)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .padding(.horizontal, 16)
                .padding(.top, 16)

                VStack(spacing: 20) {
                    AuthField(label: "Full Name", placeholder: "Alex Johnson", text: $name, icon: "person", isFocused: focusedField == .name)
                        .focused($focusedField, equals: .name)

                    AuthField(label: "Email", placeholder: "you@example.com", text: $email, icon: "envelope", keyboardType: .emailAddress, isFocused: focusedField == .email)
                        .focused($focusedField, equals: .email)

                    // Password
                    PasswordField(label: "Password", text: $password, isVisible: $isPasswordVisible, isFocused: focusedField == .password)
                        .focused($focusedField, equals: .password)

                    // Confirm
                    PasswordField(label: "Confirm Password", text: $confirmPassword, isVisible: $isConfirmVisible, isFocused: focusedField == .confirm)
                        .focused($focusedField, equals: .confirm)

                    // Password mismatch warning
                    if !confirmPassword.isEmpty && password != confirmPassword {
                        Label("Passwords don't match", systemImage: "exclamationmark.circle")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.error)
                    }

                    // Strength indicator
                    if !password.isEmpty {
                        PasswordStrengthView(password: password)
                    }

                    // Terms
                    HStack(alignment: .top, spacing: 10) {
                        Toggle("", isOn: $agreedToTerms)
                            .toggleStyle(.button)
                            .labelsHidden()
                            .tint(AppTheme.Colors.primary)

                        Group {
                            Text("I agree to the ")
                            + Text("Terms of Use").foregroundColor(AppTheme.Colors.primary).underline()
                            + Text(" and ")
                            + Text("Privacy Policy").foregroundColor(AppTheme.Colors.primary).underline()
                        }
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }

                    // Error
                    if let error = auth.errorMessage {
                        Label(error, systemImage: "exclamationmark.circle")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.error)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppTheme.Colors.errorContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.large))
                    }

                    PrimaryButton("Create Account", isLoading: auth.isLoading) {
                        focusedField = nil
                        Task { await auth.signUp(name: name, email: email, password: password) }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.5)

                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        Button("Log in", action: onBack)
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationBarHidden(true)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - Password Field
private struct PasswordField: View {
    let label: String
    @Binding var text: String
    @Binding var isVisible: Bool
    var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppTheme.Typography.labelMd)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
            HStack {
                Group {
                    if isVisible {
                        TextField("••••••••", text: $text)
                    } else {
                        SecureField("••••••••", text: $text)
                    }
                }
                .font(AppTheme.Typography.bodyMd)
                .foregroundStyle(AppTheme.Colors.onSurface)

                Button { isVisible.toggle() } label: {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(AppTheme.Colors.surfaceContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.large))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                    .strokeBorder(isFocused ? AppTheme.Colors.primary : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Password Strength
private struct PasswordStrengthView: View {
    let password: String

    private var strength: Int {
        var score = 0
        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        if password.contains(where: { $0.isNumber }) { score += 1 }
        if password.contains(where: { "!@#$%^&*".contains($0) }) { score += 1 }
        return score
    }

    private var label: String {
        switch strength {
        case 0...1: return "Weak"
        case 2: return "Fair"
        case 3: return "Good"
        default: return "Strong"
        }
    }

    private var color: Color {
        switch strength {
        case 0...1: return AppTheme.Colors.error
        case 2: return .orange
        case 3: return AppTheme.Colors.tertiary
        default: return Color(hex: "#4CAF50")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { idx in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(idx < strength ? color : AppTheme.Colors.surfaceContainer)
                        .frame(height: 4)
                }
            }
            Text("Password strength: \(label)")
                .font(AppTheme.Typography.labelSm)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(onBack: {})
            .environmentObject(AuthManager())
    }
}
