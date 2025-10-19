//
//  Card.swift
//  App Tango
//
//  単語カードのデータモデル
//  各カードは単語（term）とAI生成の定義（definition）を持つ
//

import Foundation
import SwiftData

@Model
class Card {
    @Attribute(.unique) var id: UUID
    var term: String      // 単語
    var definition: String // AI生成の定義
    var createdAt: Date
    
    var deck: Deck?
    
    init(term: String, definition: String, deck: Deck? = nil) {
        self.id = UUID()
        self.term = term
        self.definition = definition
        self.createdAt = Date()
        self.deck = deck
    }
}
