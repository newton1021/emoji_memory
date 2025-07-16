//
//  EmojiCardView.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/12/25.
//

import SwiftUI

struct EmojiCardView: View {
    @Binding var card: Card
    var cardSize: CGFloat = 100
    
    init(card: Binding<Card>, cardSize: CGFloat = 100) {
        self._card = card
        self.cardSize = cardSize
    }
    
    var body: some View {
        ZStack {
            cardFace
        }
        .frame(width: cardSize, height: cardSize)
        .rotation3DEffect(
            .degrees(card.isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.4), value: card.isFlipped)
        .transition(.opacity)
    }
    
    @ViewBuilder
    private var cardFace: some View {
        let corner = cardSize / 10
        let border = cardSize / 20
        
        let baseShape = RoundedRectangle(cornerRadius: corner)
        
        ZStack {
            if card.isFlipped {
                if #available(iOS 17.0, *) {
                    baseShape
                        .fill(.green)
                        .stroke(card.isMatched ? .red : .black, lineWidth: border)
                        .opacity(card.isMatched ? 0.5 : 0.8)
                } else {
                    // Fallback on earlier versions
                    baseShape
                        .background(Color.green)
                        .border(card.isMatched ? .red : .black, width: border)
                        .opacity(card.isMatched ? 0.5 : 0.8)
                }
                
                
                Text(card.emoji)
                    .font(.system(size: cardSize * 0.6))
            } else {
                if #available(iOS 17.0, *) {
                    baseShape
                        .fill(Color.teal)
                        .stroke(Color.black, lineWidth: border)
                } else {
                    // Fallback on earlier versions
                    baseShape
                    .background(Color.teal)
                    .border(Color.black, width: border)
                }
            }
        }
    }
}



/// A helper view to inject a @State value into previews
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}


#Preview {
    StatefulPreviewWrapper(Card(emoji: "😎")) { $card in
        VStack(spacing: 20) {
            EmojiCardView(card: $card)
            HStack {
                Button("Flip") {
                    card.isFlipped.toggle()
                }
                Button("Matched") {
                    card.isMatched.toggle()
                }
            }
        }
        .padding()
    }
}
