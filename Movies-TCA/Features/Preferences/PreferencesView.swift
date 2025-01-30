//
//  PreferencesView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Core

@ViewAction(for: PreferencesFeature.self)
struct PreferencesView: View {

    @Bindable var store: StoreOf<PreferencesFeature>
    @Environment(\.colorScheme) var colorScheme
    
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
        let appeanceImage: String = switch store.appearance {
        case .light: "sun.max.fill"
        case .dark: "moon.fill"
        case .system: colorScheme == .light ? "sun.max.fill" : "moon.fill"
        }
        
        let appearanceLabelColor: Color =  switch store.appearance {
        case .light: .orange
        case .dark: .purple
        case .system: colorScheme == .light ? .orange : .purple
        }
        
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
                systemImage: appeanceImage,
                selection: $store.appearance.rawValue.sending(\.onAppearanceChange),
                content: {
                    ForEach(Constants.Appearance.allCases.map { $0.rawValue }, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
            )
            .labelStyle(
                SettingLabelStyle(color: appearanceLabelColor)
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
