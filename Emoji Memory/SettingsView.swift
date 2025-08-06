//
//  SettingsView.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/31/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var showMessages = true
    @State private var showPreferences = false
    @State private var showTimer: Bool  = true
    @State private var volume: Float = 0.5
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Form {
            Label("Volume", systemImage: "speaker.3")
            Slider(value: $volume, in: 0...1)
            Toggle("Show messages", isOn: $showMessages)
            Toggle("Show Timer", isOn: $showTimer)
        }
    }
}

#Preview {
    SettingsView()
}
