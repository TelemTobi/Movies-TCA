//
//  PreferencesView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PreferencesView: View {

    let store: StoreOf<PreferencesFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                AppSettingsSection()
                DeviceSettingsSection()
            }
            .environmentObject(viewStore)
            .navigationTitle("Preferences")
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}

extension PreferencesView {
    
    private struct AppSettingsSection: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<PreferencesFeature>
        
        var body: some View {
            Section {
                Toggle(
                    "Adult Content",
                    systemImage: "exclamationmark.shield.fill",
                    isOn: viewStore.binding(
                        get: \.isAdultContentOn,
                        send: PreferencesFeature.Action.onAdultContentToggle
                    )
                )
                .labelStyle(SettingLabelStyle(color: .pink))
            }
        }
    }
    
    private struct DeviceSettingsSection: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<PreferencesFeature>
        
        var body: some View {
            Section {
                Button(
                    action: { viewStore.send(.onLanguageTap) },
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
                    systemImage: "sun.max.fill",
                    selection: viewStore.binding(
                        get: \.colorScheme,
                        send: PreferencesFeature.Action.onColorSchemeChange
                    ),
                    content: {
                        ForEach(Config.ColorScheme.allCases, id: \.self) {
                            Text(LocalizedStringKey($0.rawValue))
                        }
                    }
                )
                .labelStyle(SettingLabelStyle(color: .gray))
            }
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
