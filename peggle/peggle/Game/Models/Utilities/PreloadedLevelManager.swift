//
//  PreloadedLevelManager.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 3/3/24.
//

import Foundation

class PreloadedLevelManager {
    var bounds: CGRect
    
    init(bounds: CGRect = Constants.defaultBounds) {
        self.bounds = bounds
    }
    
    func createAllLevels() -> [Level] {
        var allLevels: [Level] = []
        allLevels.append(createPreloadedLevelOne())
        // TODO: add more
        return allLevels
    }
    
    func createPreloadedLevelOne() -> Level {
        let levelName = "No Exit"
        var board = Board(withSize: bounds.size)
        var objects: [BoardObject] = []
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 150.0))
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 300.0, blueStart: false))
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 450.0))
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 600.0, blueStart: false))
        board.objects = objects
        return Level(name: levelName, board: board)
    }
    
    private func createHorizontalLineOfAlternatingBlueAndOrangePegs(count: Int, atY: CGFloat, blueStart: Bool = true) -> [BoardObject] {
        let pegRadius = bounds.size.width / CGFloat(count) / 2.0
        if atY > bounds.size.width - pegRadius {
            return []
        }
        var objects: [BoardObject] = []
        for i in 0..<count {
            let pegX = pegRadius + (CGFloat(i) * 2.0 * pegRadius)
            let condition = blueStart ? i.isMultiple(of: 2) : !i.isMultiple(of: 2)
            if condition {
                let pegToAdd = Peg(center: CGPoint(x: pegX, y: atY), type: .normal, radius: pegRadius)
                objects.append(pegToAdd)
            } else {
                let pegToAdd = Peg(center: CGPoint(x: pegX, y: atY), type: .scoring, radius: pegRadius)
                objects.append(pegToAdd)
            }
        }
        return objects
    }
}
