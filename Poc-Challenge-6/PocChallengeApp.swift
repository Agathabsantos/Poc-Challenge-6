//
//  Poc_Challenge_6App.swift
//  Poc-Challenge-6
//
//  Created by Agatha Barbosa Marinho dos Santos on 29/10/26.
//

import SwiftUI
import AppIntents

@main
struct PocChallengeApp: App {
    init() {
            ShortcutsProvider.updateAppShortcutParameters()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
