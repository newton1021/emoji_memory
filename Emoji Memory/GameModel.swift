//
//  GameModel.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/14/25.
//
import SwiftUI


enum MatchResult: String {
    case luckyMatch = "Lucky Match!"
    case goodMemory = "Good Memory!"
    case thereItIs = "There it is!"
    case finallyFoundIt = "Good Job!"
    case thatTookAWhile = "That took a while"
    case notAMatch = "Not a match"
}



class GameModel: ObservableObject {
    
    @Published var deck: [Card] = []
    @Published var selectedIndices: [Int] = []
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var moves: Int = 0
    @Published var matchResults: MatchResult = .notAMatch
    
    @AppStorage("BestScore") var bestScore: Int = 100
    
    func updateHighScoreIfNeeded() {
            if moves < bestScore {
                bestScore = moves
            }
        }
    
    var deckSize: Int {
        return deck.count
    }
    
    init() {
        MakeDeck()
    }
    
    init(deckSize: Int) {
        MakeDeck(size: deckSize)
    }
    
    ///
    /// Future idea:
    ///         This function may let the user set the number of card pairs in the deck or it may filter by type
    ///
    func MakeDeck(size: Int = 8) {
        score = 0
        moves = 0
        isGameOver = false
        selectedIndices.removeAll()
        
        if size < emojis.count && size > 2 {
            let subset = Array(emojis.shuffled().prefix(size))
            let all = (subset + subset).shuffled()
            self.deck = all.map { Card(emoji: $0) }
        }
        else {
            let all = (emojis + emojis).shuffled()
            self.deck = all.map { Card(emoji: $0) }
        }
    }
    func selectCard(at index: Int) {
        matchResults = .notAMatch
        guard !deck[index].isMatched,
              !deck[index].isFlipped,
              selectedIndices.count < 2,
              !selectedIndices.contains(index)
        else { return }
        
        deck[index].flip()
        selectedIndices.append(index)
        
        if selectedIndices.count == 2 {
            checkForMatch()
        }
    }
    
    //MARK CheckForMatch
    /// Check if the two cards are a match
    /// - note: selectedIndices is set it the selectCard function
    ///         Sets a thread to flip the cards back over after 1 sec if there is no match..
    private func checkForMatch() {
        guard selectedIndices.count == 2 else { return }
        
        let firstIndex = selectedIndices[0]
        let secondIndex = selectedIndices[1]
        moves += 1 //update the number of moves
        
        if deck[firstIndex] == deck[secondIndex] {
            deck[firstIndex].isMatched = true
            deck[secondIndex].isMatched = true
            
            matchResults = evaluateMatch(cardA: deck[firstIndex].lookCount, cardB: deck[secondIndex].lookCount)
            
            selectedIndices.removeAll()
            score += 1
            if deck.allSatisfy(\.isMatched) {
                isGameOver = true
                updateHighScoreIfNeeded()
            }
        }
        
        
      
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.deck[firstIndex].flip()
                self.deck[secondIndex].flip()
                self.selectedIndices.removeAll()
            }
        }
    }
    
    
    private func evaluateMatch(cardA: Int, cardB: Int) -> MatchResult {
        switch (cardA, cardB) {
        case (let a, let b) where a == 1 && b == 1:
            return .luckyMatch
        case (1, let b) where b > 1:
            return .goodMemory
        case (let a, 1) where a > 1:
            return .thereItIs
        case (let a, let b) where a > 4 && b > 4:
            return .thatTookAWhile
        case (let a, let b) where a > 2 && b > 2:
            return .finallyFoundIt
        default:
            return .notAMatch
        }
    }

    
}
