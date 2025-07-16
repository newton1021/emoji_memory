//
//  GameOverSheet.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/16/25.
//
import SwiftUI

struct GameOverSheet: View {
    let moves: Int
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(LinearGradient(colors: [.blue, .teal,.cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack {
                
                Text("😎")
                    .font(.system(size: 150))
                
                if #available(iOS 16.0, *) {
                    Text("You Did It!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(15)
                    Text("It took you \(moves) moves.")
                        .font(.system(size: 35))
                        .foregroundStyle(.white, .yellow)
                        .fontWeight(.bold)
                        .padding(15)
                        
                } else {
                    Text("You Did It!")
                        .font(.largeTitle)
                    Text("It took you \(moves) moves.")
                        .foregroundStyle(.white)
                }
            }
        }.onTapGesture {
            onRestart()
        }
    }
}

#Preview {
    GameOverSheet(moves: 33, onRestart: {print("Restarted!")})
}
