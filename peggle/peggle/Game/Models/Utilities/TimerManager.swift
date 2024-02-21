//
//  TimerManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 17/2/24.
//

import Foundation

class TimerManager {
    private var gameTimer: Timer?
    let timeInterval: TimeInterval
    private var update: (() -> Void)?

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    func startTimer(update: @escaping () -> Void) {
        invalidateTimer()

        self.update = update
        gameTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.update?()
        }
    }

    func invalidateTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}
