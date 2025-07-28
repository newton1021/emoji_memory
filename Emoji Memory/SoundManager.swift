//
//  SoundManager.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/17/25.
//

import Foundation
import AVFoundation                                                                             

class SoundManager {
    static var players: [AVAudioPlayer] = []
    
    static func playsound(named name: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Sound file not found: \(name).\(ext)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            players.append(player)
            player.play()

            // Clean up finished players
            player.delegate = PlayerDelegate.shared
        } catch {
            print("Could not load sound file: \(error.localizedDescription)")
        }
    }

    // Simple delegate to remove finished players
    private class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
        static let shared = PlayerDelegate()

        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            if let index = SoundManager.players.firstIndex(of: player) {
                SoundManager.players.remove(at: index)
            }
        }
    }
}
