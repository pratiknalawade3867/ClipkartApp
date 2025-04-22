import SwiftUI
import CoreData

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    Section {
                            HStack(spacing: 16) {
                                Image(systemName: "person.crop.circle.fill")  // Placeholder for a user avatar
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(SessionManager.shared.currentUser?.fullName.uppercased() ?? "Unknown User")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text(SessionManager.shared.currentUser?.email.lowercased() ?? ViewStrings.blank.getText())
                                        .font(.footnote)
                                }
                            }
                            
                            Button {
                                Task {
                                    SessionManager.shared.currentUser? = UserTags(email: "", fullName: "", password: "", confirmPassword: "")
                                }
                            } label: {
                                Label {
                                    Text(ViewStrings.deleteAccountTxt.getText())
                                        .foregroundColor(.primary)
                                } icon: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                    }
                }
                .navigationTitle(ViewStrings.profileLbl.getText())
                .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text(ViewStrings.profileLbl.getText())
            }
            
            NavigationStack {
                SettingsView()
                    .navigationTitle(ViewStrings.settingLbl.getText())
                    .navigationBarBackButtonHidden(true)
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text(ViewStrings.settingLbl.getText())
            }
        }
        .background(
            NavigationLink(destination: LoginView(), isActive: $viewModel.isAccountDeleted) {
                EmptyView()
            }
        )
    }
}

#Preview {
    ProfileView()
}
