//
//  App_TangoApp.swift
//  App Tango
//
//  Apple Intelligence搭載 AI単語帳アプリ
//  iOS 26のFoundation Models Frameworkを使用
//

import SwiftUI
import SwiftData

@main
struct App_TangoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Deck.self, Card.self, ActivityLog.self])
    }
}
