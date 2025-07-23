//
//  ContentView.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/12/25.
//

import SwiftUI

struct GameBoardView: View {
    @StateObject private var cardDeck: GameModel = GameModel(deckSize: 12)
    @State private var cardSize: CGFloat = 100
    @State private var showMessage: Bool  = false
    @State private var dealtIndices: Set<Int>  = []
    var body: some View {
        
        
        
        GeometryReader { geometry in
            ZStack {
                BackgroundGradient()
                
                VStack {
                    //title text
                    TitleView()
                    // Score board
                    ScoreBoardView(score: cardDeck.score, moves: cardDeck.moves,
                                   bestScore: cardDeck.bestScore)
                    
                    //Game board
                    let (_ , columns, cardSize) = bestGridLayout(for: cardDeck.deckSize, in: geometry)
                    let gridItems = Array(repeating: GridItem(.flexible()), count: columns)
                    

                    GameGrid(cardDeck: cardDeck,
                             columns: columns,
                             gridItems: gridItems,
                             cardSize: cardSize,
                             dealtIndices: dealtIndices
                    )
                    
                    //Restart button
                    RestartButton{
                        cardDeck.MakeDeck(size: 12)
                        dealCards()
                    }
                    
                    //Game over sheet
                    .sheet(isPresented: $cardDeck.isGameOver){
                        GameOverSheet(moves: cardDeck.moves) {
                            
                            cardDeck.MakeDeck(size: 12)
                            dealCards()
                        }
                    }
                }
                
                MatchMessageView(message: cardDeck.matchResults.rawValue, visible: showMessage)
                
            }
            
            .modifier(MatchResultChangeHandler(matchResult: cardDeck.matchResults) {
                        handleMatchAnimation()
                    })
           
        }
        .onAppear {
                   dealCards()
               }
    }
    
    private func handleMatchAnimation() {
        withAnimation(.easeInOut(duration: 1)) {
            showMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showMessage = false
            }
        }
    }
    
    private func dealCards() {
        // Simulate dealing by revealing one card at a time
        dealtIndices.removeAll()
        for index in cardDeck.deck.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                dealtIndices.insert(index)
            }
        }
    }
    
    func gridSize(for count: Int) -> (rows: Int, columns: Int) {
        let root = Int(Double(count).squareRoot())
        for i in stride(from: root, through: 1, by: -1) {
            if count % i == 0 {
                return (rows: 1,columns:  i)
            }
        }
        // Fallback — should never happen for 2n
        return (rows: count, columns: 1)
    }
    
    func bestGridLayout(for count: Int, in geometry: GeometryProxy) -> (rows: Int, columns: Int, cardSize: CGFloat) {
        let availableWidth = geometry.size.width
        let availableHeight = geometry.size.height * 0.7 // Adjust for title/score/buttons

        var bestLayout: (rows: Int, columns: Int, cardSize: CGFloat) = (count, 1, 0)

        for columns in 1...count {
            let rows = Int(ceil(Double(count) / Double(columns)))

            let cardWidth = 0.9 * availableWidth / CGFloat(columns)
            let cardHeight = 0.9 * availableHeight / CGFloat(rows)
            let cardSize = min(cardWidth, cardHeight) * 0.95

            if cardSize > bestLayout.cardSize {
                bestLayout = (rows, columns, cardSize)
            }
        }

        return bestLayout
    }
}

#Preview {
    GameBoardView()
}



struct MatchResultChangeHandler: ViewModifier {
    let matchResult: MatchResult
    let onChange: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            return content
                .onChange(of: matchResult) { _, newValue in
                    if newValue != .notAMatch {
                        onChange()
                    }
                }
        } else {
            return content
                .onChange(of: matchResult) { newValue in
                    if newValue != .notAMatch {
                        onChange()
                    }
                }
        }
    }
}


struct BackgroundGradient: View {
    var body: some View {
        Rectangle() //background color
            .ignoresSafeArea(edges: .all)
            .foregroundStyle(
                LinearGradient(
                    colors: [ Color(white: 0.5), Color.white, Color.blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

struct TitleView: View {
    var body: some View {
        Text("Memory Game")
            .font(.system(size: 44, weight: .bold, design: .serif))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color.blue,
                        Color.purple,
                        Color.red
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .brown.opacity(0.4), radius: 4, x: 1, y: 2)
    }
}

struct ScoreBoardView: View {
    let score: Int
    let moves: Int
    let bestScore: Int
    var body: some View {
        
        HStack {
            if bestScore < 100 {
                Text("Best: \(bestScore)")
                    .font(.title)
            }
            
            Spacer()
            if #available(iOS 16.0, *) {
                Text("Moves: \(moves)")
                    .font(.title)
                    .foregroundStyle(.indigo)
                    .bold(true)
            } else {
                // Fallback on earlier versions
                Text("Moves: \(moves)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.indigo)
            }
        }
        .padding(.horizontal)
    }
}

struct RestartButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Restart")
                .font(.title)
                .fontWeight(.semibold)
                .shadow(color: .black, radius: 5, x: 3, y: 3)
        }
        .frame(width: 300, height: 50)
        .background(Color(white: 0.5))
        .clipShape(Capsule())
        .foregroundStyle(.green)
        .shadow(color: .black, radius: 5, x: 3, y: 3)
        .padding()
    }
}



struct MatchMessageView: View {
    let message: String
    let visible: Bool
    
    var body: some View {
        Text(message)
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .rotationEffect(.degrees(Double.random(in: -30...30)))
            .foregroundColor(.white)
            .opacity(visible ? 1 : 0)
    }
}




