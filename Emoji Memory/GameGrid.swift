//
//  GameGrid.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/16/25.
//

import SwiftUI

struct GameGrid: View {
    @ObservedObject var cardDeck: GameModel
    let columns: Int
    let gridItems: [GridItem]
    let cardSize: CGFloat

    var dealtIndices: Set<Int> = []
    
    var body: some View {
        ScrollView {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 3)
                            .shadow(radius: 5, x: 3, y: 5)
                    )
                
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(cardDeck.deck.indices, id: \.self) { index in
                        EmojiCardView(
                            card: $cardDeck.deck[index],
                            cardSize: cardSize
                        )
                        .rotationEffect(dealtIndices.contains(index) ? .zero : .degrees(180))
                        .opacity(dealtIndices.contains(index) ? 1 : 0)
                        .offset(x: dealtIndices.contains(index) ? 0 : 500, y: dealtIndices.contains(index) ? 0 : -500)
                        
//                        .animation(
//                            .easeOut.delay(dealtIndices.contains(index) ? Double(index) * 0.1 : 0.1),
//                            value: dealtIndices
//                        )
                        
                        .onTapGesture {
                            cardDeck.selectCard(at: index)
                        }
                    }
                }
                .padding(10)
            }
            .padding(.vertical, 10)
        }
        .padding(.horizontal, 20)
        
    }
    

}

#Preview {
    let dummyModel = GameModel(deckSize: 12)
    let columns = 4
    
    let gridItems = Array(repeating: GridItem(.flexible()), count: columns)
    let cardSize: CGFloat = 80
    
    
    
    
    
    GameGrid(
        cardDeck: dummyModel,
        columns: columns,
        gridItems: gridItems,
        cardSize: cardSize
    )
    
//    dealCards(dummyModel: dummyModel)
    
   
}
//func dealCards(dummyModel: GameModel ){
//    for index in dummyModel.deck.indices {
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
//            dummyModel.dealtIndices.insert(index)
//            
//        }
//    }
//}
