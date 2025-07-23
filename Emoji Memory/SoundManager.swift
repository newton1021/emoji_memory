//
//  SoundManager.swift
//  Emoji Memory
//
//  Created by Geoffrey Flynn on 7/17/25.
//

import Foundation
import AVFoundation                                                                             

class SoundManager {
    static var player: AVAudioPlayer?
    
    static func playsound(named name: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Sound file not found: \(name).\(ext)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
