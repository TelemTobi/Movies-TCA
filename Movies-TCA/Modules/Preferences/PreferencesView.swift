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
                DeviceSettingsSection()
            }
            .environmentObject(viewStore)
            .navigationTitle("Preferences")
        }
    }
}

extension PreferencesView {
    
    private struct DeviceSettingsSection: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<PreferencesFeature>
        
        var body: some View {
            Section {
                Button(
                    action: { viewStore.send(.onLanguageTap) },
                    label: {
                        HStack {
                            Label("Language", systemImage: "globe")
                                .labelStyle(SettingLabelStyle(color: .blue))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                )
                .buttonStyle(.plain)
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
