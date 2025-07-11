//
//  PreferencesView.swift
//  Presentation
//
//  Created by Telem Tobi on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Core
import DesignSystem

@ViewAction(for: Preferences.self)
public struct PreferencesView: View {

    @Bindable public var store: StoreOf<Preferences>
    @Environment(\.colorScheme) var colorScheme
    
    public init(store: StoreOf<Preferences>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Group {
                    AppSettingsSection()
                    DeviceSettingsSection()
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollBounceBehavior(.basedOnSize)
            .contentMargins(16, for: .scrollContent)
            .navigationTitle(.localized(.preferences))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension PreferencesView {
    
    @ViewBuilder
    private func AppSettingsSection() -> some View {
        VStack {
            Toggle(
                isOn: $store.isAdultContentOn.sending(\.onAdultContentToggle),
                label: {
                    Label(
                        .localized(.adultContent),
                        systemImage: "exclamationmark.shield.fill"
                    )
                    .labelStyle(.setting(color: .pink))
                }
            )
        }
        .padding()
        .backgroundColor(.foreground)
        .clipShape(.rect(cornerRadius: 10))
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
        
        VStack(spacing: 20) {
            Button(
                action: { send(.onLanguageTap) },
                label: {
                    HStack {
                        Label(.localized(.language), systemImage: "globe")
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(.rect)
                    .labelStyle(.setting(color: .blue))
                }
            )
            .buttonStyle(.plain)

            Divider()
            
            Picker(
                selection: $store.appearance.sending(\.onAppearanceChange),
                content: {
                    ForEach(Constants.Appearance.allCases, id: \.self) { appearance in
                        let title: Localization = switch appearance {
                        case .system: .system
                        case .light: .light
                        case .dark: .dark
                        }
                        
                        Text(LocalizedStringKey.localized(title))
                            .tag(appearance)
                    }
                },
                label: {
                    Label(
                        .localized(.appearance),
                        systemImage: appeanceImage
                    )
                    .labelStyle(.setting(color: appearanceLabelColor))
                }
            )
        }
        .padding()
        .backgroundColor(.foreground)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.vertical)
    }
}

#Preview {
    NavigationStack {
        PreferencesView(
            store: Store(
                initialState: Preferences.State(),
                reducer: { Preferences() }
            )
        )
    }
}
