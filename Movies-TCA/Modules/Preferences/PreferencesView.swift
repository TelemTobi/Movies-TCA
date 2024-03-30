//
//  PreferencesView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: PreferencesFeature.self)
struct PreferencesView: View {

    @Bindable var store: StoreOf<PreferencesFeature>
    
    var body: some View {
        List {
            AppSettingsSection()
            DeviceSettingsSection()
        }
        .navigationTitle("Preferences")
    }
}

extension PreferencesView {
    
    @ViewBuilder
    private func AppSettingsSection() -> some View {
        Section {
            Toggle(
                "Adult Content",
                systemImage: "exclamationmark.shield.fill",
                isOn: $store.isAdultContentOn.sending(\.onAdultContentToggle)
            )
            .labelStyle(SettingLabelStyle(color: .pink))
        }
    }
    
    @ViewBuilder
    private func DeviceSettingsSection() -> some View {
        @Environment(\.colorScheme) var colorScheme
        
        Section {
            Button(
                action: { send(.onLanguageTap) },
                label: {
                    HStack {
                        Label("Language", systemImage: "globe")
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .labelStyle(SettingLabelStyle(color: .blue))
                }
            )
            .buttonStyle(.plain)
            
            Picker(
                "Appearance",
                systemImage: colorScheme == .light ? "sun.max.fill" : "moon.fill",
                selection: $store.appearance.sending(\.onAppearanceChange),
                content: {
                    ForEach(Preferences.Appearance.allCases.map { $0.rawValue }, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
            )
            .labelStyle(
                SettingLabelStyle(color: colorScheme == .light ? .orange : .purple)
            )
        }
    }
}

#Preview {
    NavigationStack {
        PreferencesView(
            store: Store(
                initialState: PreferencesFeature.State(),
                reducer: { PreferencesFeature() }
            )
        )
    }
}
