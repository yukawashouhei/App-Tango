//
//  ContentView.swift
//  App Tango
//
//  メインエントリーポイント
//  DeckListViewを表示
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        DeckListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Deck.self, Card.self, ActivityLog.self])
}
