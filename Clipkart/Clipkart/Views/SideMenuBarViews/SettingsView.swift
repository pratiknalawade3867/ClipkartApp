//
//  SettingsView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 28/10/24.
//

import SwiftUI

struct SettingsView: View {
    // MARK:  Dark Mode Setting (Using @AppStorage to persist across sessions)
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // MARK:  Dummy App Version
    let appVersion = "1.0.0"
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // MARK:  Dark Mode Toggle
                    Section(header: Text("Appearance")) {
                        Toggle(isOn: $isDarkMode) {
                            Text("Dark Mode")
                        }
                        .onChange(of: isDarkMode) { value in
                            // MARK:  Update the color scheme based on the dark mode toggle
                            UIApplication.shared.windows.first?.rootViewController?.view.overrideUserInterfaceStyle = value ? .dark : .light
                        }
                    }
                    
                    // MARK:  App Version Display
                    Section(header: Text("App Info")) {
                        HStack {
                            Text("App Version")
                            Spacer()
                            Text(appVersion)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // MARK:  More Settings Section
                    Section(header: Text("More Settings")) {
                        NavigationLink(destination: Text("Account Settings")) {
                            HStack {
                                Text("Account Settings")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink(destination: Text("Notification Settings")) {
                            HStack {
                                Text("Notifications")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink(destination: Text("Privacy Policy")) {
                            HStack {
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Settings")
            .navigationBarBackButtonHidden(true)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)  // Applying the selected theme
    }
}

#Preview {
    SettingsView()
        .environment(\.colorScheme, .light)  // Initial light mode
}
