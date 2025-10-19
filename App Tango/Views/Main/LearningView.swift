//
//  LearningView.swift
//  App Tango
//
//  学習画面
//  カードフリップアニメーションで単語と定義を表示
//

import SwiftUI
import SwiftData

struct LearningView: View {
    let cards: [Card]
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var showCompletion = false
    
    var body: some View {
        ZStack {
            // グラデーション背景
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.95, blue: 1.0),
                    Color(red: 0.95, green: 0.90, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showCompletion {
                // 完了画面
                CompletionView(onDismiss: {
                    dismiss()
                })
            } else if !cards.isEmpty {
                VStack(spacing: 30) {
                    // デッキ名とプログレス
                    VStack(spacing: 10) {
                        if let deckName = cards[currentIndex].deck?.name {
                            Text(deckName)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(currentIndex + 1) / \(cards.count)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // カードフリップビュー
                    FlipCardView(
                        card: cards[currentIndex],
                        isFlipped: $isFlipped
                    )
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // 次へボタン
                    Button(action: nextCard) {
                        HStack {
                            Text("次へ")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func nextCard() {
        // カードをリセット
        isFlipped = false
        
        // 次のカードへ
        if currentIndex < cards.count - 1 {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                currentIndex += 1
            }
        } else {
            // 全カード完了
            showCompletion = true
        }
    }
}

// カードフリップビュー（Apple公式推奨の方法）
struct FlipCardView: View {
    let card: Card
    @Binding var isFlipped: Bool
    
    var body: some View {
        ZStack {
            // 表面（単語）
            CardFaceView(text: card.term, isLarge: true)
                .opacity(isFlipped ? 0 : 1)
            
            // 裏面（定義）
            CardFaceView(text: card.definition, isLarge: false)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }
}

// カード面ビュー（横長長方形、固定サイズ）
struct CardFaceView: View {
    let text: String
    let isLarge: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            
            Text(text)
                .font(isLarge ? .system(size: 36, weight: .bold) : .system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
        }
        .frame(width: 340, height: 200)
    }
}

// 完了画面
struct CompletionView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("学習完了！")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("お疲れ様でした😊")
                .font(.title3)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: onDismiss) {
                Text("閉じる")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    @Previewable @State var previewContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Deck.self, Card.self, configurations: config)
        let deck = Deck(name: "iOS Swift")
        let card1 = Card(term: "Swift Testing", definition: "Swift Testingは、2024年のWWDCで発表された、XCTestに代わる新しいテストフレームワークです。", deck: deck)
        let card2 = Card(term: "SwiftUI", definition: "SwiftUIは、Appleのプラットフォーム向けの宣言的UIフレームワークです。", deck: deck)
        container.mainContext.insert(deck)
        container.mainContext.insert(card1)
        container.mainContext.insert(card2)
        return container
    }()
    
    NavigationStack {
        LearningView(cards: (try? previewContainer.mainContext.fetch(FetchDescriptor<Card>())) ?? [])
            .modelContainer(previewContainer)
    }
}
