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
        .bounce: "bounce2",
        .clear: "clear",
        .interface: "interface",
        .gameOver: "game-over",
        .cannon: "cannon",
        .win: "win",
        .select: "select",
        .bubble: "bubble",
        .tick: "tick"
    ]
    private let playersPerSound = 7

    init() {
        preloadSounds()
    }

    private func preloadSounds() {
        for (soundType, soundName) in soundNames {
            var playersForSound: [AVAudioPlayer] = []
            guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { continue }
            for _ in 0..<playersPerSound {
                do {
                    let player = try AVAudioPlayer(contentsOf: soundURL)
                    player.prepareToPlay()
                    playersForSound.append(player)
                } catch {
                    print("Failed to preload sound: \(soundName), error: \(error)")
                }
            }

            players[soundType] = playersForSound
        }
    }

    func playSound(sound: SoundType) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            if let player = self.players[sound]?.first(where: { !$0.isPlaying }) {
                player.play()
            }
        }
    }
}

enum SoundType {
    case bounce, clear, interface, gameOver, cannon, win, select, bubble, tick
}
