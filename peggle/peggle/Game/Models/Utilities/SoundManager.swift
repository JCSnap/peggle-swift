//
//  SoundManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 28/2/24.
//

import Foundation
import AVFoundation

class SoundManager {
    private var players: [SoundType: [AVAudioPlayer]] = [:]
    private let soundNames: [SoundType: String] = [
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

    init() {
        preloadSounds()
    }

    private func preloadSounds() {
        for (soundType, soundName) in soundNames {
            guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { continue }
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.prepareToPlay()
                players[soundType] = [player]
            } catch {
                print("Failed to preload sound: \(soundName), error: \(error)")
            }
        }
    }

    func playSound(sound: SoundType) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, let soundURL = Bundle.main.url(forResource: self.soundNames[sound], withExtension: "mp3") else { return }

            if let player = self.players[sound]?.first(where: { !$0.isPlaying }) {
                player.play()
            } else {
                do {
                    let newPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    newPlayer.prepareToPlay()
                    newPlayer.play()
                    self.players[sound]?.append(newPlayer)
                } catch {
                    print("Failed to create sound player for \(sound): \(error)")
                }
            }
        }
    }
}


enum SoundType {
    case bounce, clear, interface, gameOver, cannon, win, select, bubble, tick
}
