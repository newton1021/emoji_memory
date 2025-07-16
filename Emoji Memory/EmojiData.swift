//
//  EmojiData.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/12/25.
//

import Foundation

let emojis = ["🐶", "🐱", "🐭", "🦊", "🐻", "🐼", "🐸", "🐵", "🦄", "🐦", "🐧", "🦆", "🦅", "🦉", "🦢", "🦜", "🦔", "🦗", "🦖", "🦕", "🦓", "🦒", "🦞", "🦚", "🦙", "🐝", "🐞", "🐳", "🐴", "🌼", "🍎", "🍇", "🍊", "🍋", "🍌", "🍉", "🍒", "🍑", "🍐", "🍏", "🥨", "🍟", "🍕", "🍔", "🍭", "🍬", "🍫", "🍪", "🍩", "🍰"]


struct Card: Identifiable {
    let id = UUID()
    let emoji: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
    var lookCount: Int = 0
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.emoji == rhs.emoji
    }
    mutating func flip() {
        lookCount += isFlipped ? 0 : 1
        isFlipped.toggle()
    }
    
    mutating func matched(){
        isMatched.toggle()
    }
    
    mutating func reset() {
        isFlipped = false
        isMatched = false
        lookCount = 0
    }
}

