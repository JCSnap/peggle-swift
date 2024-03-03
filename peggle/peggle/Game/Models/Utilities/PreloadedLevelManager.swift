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
        allLevels.append(createPreloadedLevelTwo())
        // TODO: add more
        return allLevels
    }
    
    var preloadedLevelNames: [String] {
        ["No Escape", "Variations are Good 👍"]
    }
    
    func createPreloadedLevelOne() -> Level {
        let levelName = preloadedLevelNames[0]
        var board = Board(withSize: bounds.size)
        var objects: [BoardObject] = []
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 150.0))
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 300.0, blueStart: false))
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 450.0))
        objects.append(contentsOf: createHorizontalLineOfAlternatingBlueAndOrangePegs(count: 12, atY: 600.0, blueStart: false))
        board.objects = objects
        return Level(name: levelName, board: board)
    }
    
    func createPreloadedLevelTwo() -> Level {
        let levelName = preloadedLevelNames[1]
        var board = Board(withSize: bounds.size)
        var objects: [BoardObject] = []
        let cornerBlocks = createBlocksOfDifferentSizesAndAnglesAtCorners()
        objects.append(contentsOf: cornerBlocks)
        let pegs = createScatteredPegsOfDifferentTypesAndSizesAndAngles()
        objects.append(contentsOf: pegs)
        board.objects = objects
        let level = Level(name: levelName, board: board)
        return level
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
    
    private func createBlocksOfDifferentSizesAndAnglesAtCorners() -> [BoardObject] {
        let sizes = [20, 30, 40, 50]
        let angles = [2.25, 0.72, 1.07, 3,03]
        let maxX = bounds.size.width
        let maxY = bounds.size.height
        let offsets = sizes.map { $0 * 3 }
        let corners: [CGPoint] = [
            CGPoint(x: CGFloat(offsets[0]), y: CGFloat(offsets[0])),
            CGPoint(x: maxX - CGFloat(offsets[1]), y: CGFloat(offsets[1])),
            CGPoint(x: CGFloat(offsets[3]), y: maxY - CGFloat(offsets[3])),
            CGPoint(x: maxX - CGFloat(offsets[3]), y: maxY - CGFloat(offsets[3]))
        ]
        var objects: [BoardObject] = []
        for i in 0..<4 {
            let block = Obstacle(center: corners[i], type: .rectangle, angle: angles[i])
            block.updateSize(to: CGFloat(sizes[i]))
            objects.append(block)
        }
        return objects
    }
    
    private func createScatteredPegsOfDifferentTypesAndSizesAndAngles() -> [BoardObject] {
        let sizes = [20.5, 40.5, 30, 20, 50, 25, 26.6, 24.3, 29, 29, 23, 40]
        let angles = [2.2, 4.2, 2.1, 1.0, 0, 0, 0.5, 2.2, 1.2, 3.2, 2.2, 1.3]
        let yPositions = [300.0, 440.5, 650.0]
        var pegs: [BoardObject] = []
        let spacing = 50.0

        for i in 0..<sizes.count {
            let typeIndex = i % 4
            let yIndex = i % 3
            let xStart = 200.0
            let xPosition = xStart + CGFloat(typeIndex) * 50.0 + spacing * CGFloat(typeIndex + 1)
            let yRandom = i.isMultiple(of: 2) ? 50.0 : -50.0
            let yPosition = yPositions[yIndex] + yRandom
            let center = CGPoint(x: xPosition, y: yPosition)
            var peg: Peg
            if typeIndex == 0 {
                peg = Peg(center: center, type: .normal, radius: sizes[i], angle: angles[i])
            } else if typeIndex == 1 {
                peg = Peg(center: center, type: .scoring, radius: sizes[i], angle: angles[i])
            } else if typeIndex == 2 {
                peg = Peg(center: center, type: .exploding, radius: sizes[i], angle: angles[i])
            } else {
                peg = Peg(center: center, type: .stubborn, radius: sizes[i], angle: angles[i])
            }
            pegs.append(peg)
        }
        return pegs
    }
}
