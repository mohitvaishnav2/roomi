import SwiftUI

// MARK: - Login View (Screen 05)
struct LoginView: View {
    let onNavigateToRegister: () -> Void

    @EnvironmentObject private var auth: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showError = false
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Header
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [Color(hex: "#F8D7CC"), Color(hex: "#DFC0B5"), AppTheme.Colors.surfaceContainerHigh],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 220)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back")
                            .font(AppTheme.Typography.displayLg)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                        Text("Sign in to continue designing")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                    }
                    .padding(28)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xxl))
                .padding(.horizontal, 16)
                .padding(.top, 16)

                VStack(spacing: 24) {
                    // Email
                    AuthField(
                        label: "Email",
                        placeholder: "you@example.com",
                        text: $email,
                        icon: "envelope",
                        keyboardType: .emailAddress,
                        isFocused: focusedField == .email
                    )
                    .focused($focusedField, equals: .email)

                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        HStack {
                            Group {
                                if isPasswordVisible {
                                    TextField("••••••••", text: $password)
                                } else {
                                    SecureField("••••••••", text: $password)
                                }
                            }
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurface)
                            .focused($focusedField, equals: .password)

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(AppTheme.Colors.surfaceContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.large))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                                .strokeBorder(
                                    focusedField == .password ? AppTheme.Colors.primary : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                    }

                    // Forgot Password
                    HStack {
                        Spacer()
                        Button("Forgot password?") {}
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.primary)
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

                    // Sign In Button
                    PrimaryButton("Sign In", isLoading: auth.isLoading) {
                        focusedField = nil
                        Task { await auth.signIn(email: email, password: password) }
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1.0)

                    // Divider
                    HStack {
                        Rectangle().fill(AppTheme.Colors.outlineVariant).frame(height: 1)
                        Text("or").font(AppTheme.Typography.labelSm).foregroundStyle(AppTheme.Colors.outline)
                        Rectangle().fill(AppTheme.Colors.outlineVariant).frame(height: 1)
                    }

                    // Social Sign In
                    SocialSignInButton(provider: "Apple") {}
                    SocialSignInButton(provider: "Google") {}

                    // Register Link
                    HStack(spacing: 4) {
                        Text("New to RoomIQ?")
                            .font(AppTheme.Typography.bodyMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        Button("Create account", action: onNavigateToRegister)
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

// MARK: - Auth Field
struct AuthField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppTheme.Typography.labelMd)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        .frame(width: 20)
                }
                TextField(placeholder, text: $text)
                    .font(AppTheme.Typography.bodyMd)
                    .foregroundStyle(AppTheme.Colors.onSurface)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
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

// MARK: - Social Sign In Button
struct SocialSignInButton: View {
    let provider: String
    let action: () -> Void

    var icon: String {
        provider == "Apple" ? "apple.logo" : "globe"
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                Text("Continue with \(provider)")
                    .font(AppTheme.Typography.labelMd)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(AppTheme.Colors.onSurface)
            .background(AppTheme.Colors.surfaceContainer)
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(AppTheme.Colors.outlineVariant, lineWidth: 1))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NavigationStack {
        LoginView(onNavigateToRegister: {})
            .environmentObject(AuthManager())
    }
}
