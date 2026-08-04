import SwiftUI

// MARK: - Edit Profile View (Screen 28)
struct EditProfileView: View {
    @EnvironmentObject private var auth: AuthManager
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var location: String = ""
    @State private var isSaving = false
    @FocusState private var focusedField: Field?

    private enum Field { case name, bio, location }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.Colors.primary, AppTheme.Colors.primaryContainer],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)
                    Text(String(name.prefix(1).uppercased()))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Button {} label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(AppTheme.Colors.primary, in: Circle())
                            .overlay(Circle().strokeBorder(.white, lineWidth: 2))
                    }
                    .offset(x: 4, y: 4)
                }
                .padding(.top, 16)

                // Form Fields
                VStack(spacing: 20) {
                    AuthField(label: "Full Name", placeholder: "Your name", text: $name, icon: "person", isFocused: focusedField == .name)
                        .focused($focusedField, equals: .name)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(AppTheme.Typography.labelMd)
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        TextEditor(text: $bio)
                            .font(AppTheme.Typography.bodyMd)
                            .focused($focusedField, equals: .bio)
                            .frame(minHeight: 80)
                            .padding(14)
                            .background(AppTheme.Colors.surfaceContainer, in: RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                        Text("\(bio.count)/160")
                            .font(AppTheme.Typography.labelSm)
                            .foregroundStyle(AppTheme.Colors.outline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    AuthField(label: "Location", placeholder: "City, Country", text: $location, icon: "mappin", isFocused: focusedField == .location)
                        .focused($focusedField, equals: .location)
                }
                .padding(.horizontal, 24)

                // Danger Zone
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account")
                        .font(AppTheme.Typography.labelSm)
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                        .padding(.horizontal, 24)

                    VStack(spacing: 0) {
                        Button {} label: {
                            HStack {
                                Image(systemName: "lock").foregroundStyle(AppTheme.Colors.primary).frame(width: 20)
                                Text("Change Password")
                                    .font(AppTheme.Typography.bodyMd).foregroundStyle(AppTheme.Colors.onSurface)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(AppTheme.Colors.outlineVariant)
                            }
                            .padding(.horizontal, 20).padding(.vertical, 14)
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Divider().padding(.leading, 54)

                        Button {} label: {
                            HStack {
                                Image(systemName: "trash").foregroundStyle(AppTheme.Colors.error).frame(width: 20)
                                Text("Delete Account")
                                    .font(AppTheme.Typography.bodyMd).foregroundStyle(AppTheme.Colors.error)
                                Spacer()
                            }
                            .padding(.horizontal, 20).padding(.vertical, 14)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .background(AppTheme.Colors.surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl))
                    .padding(.horizontal, 16)
                }

                PrimaryButton("Save Changes", isLoading: isSaving) {
                    isSaving = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        isSaving = false
                        dismiss()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            name = auth.currentUser?.name ?? ""
            bio = auth.currentUser?.bio ?? ""
            location = auth.currentUser?.location ?? ""
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environmentObject(AuthManager())
    }
}
