//
//  SoundManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 28/2/24.
//

import Foundation
import AVFoundation

class SoundManager {
    private var player: AVAudioPlayer?
    
    func playSound(sound: SoundType) {
        let soundNames: [SoundType: String] = [
            .bounce: "bounce",
            .clear: "clear",
            .interface: "interface",
            .gameOver: "game-over",
            .cannon: "cannon",
            .win: "win",
            .select: "select",
            .bubble: "bubble",
            .tick: "tick"
        ]
        let soundName = soundNames[sound]
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print("Failed to load the sound: \(error)")
        }
        player?.play()
    }
}

enum SoundType {
    case bounce, clear, interface, gameOver, cannon, win, select, bubble, tick
}
