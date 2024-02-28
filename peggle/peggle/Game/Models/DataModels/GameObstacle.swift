//
//  GameObstacle.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 27/2/24.
//

import Foundation

class GameObstacle: GameObject {
    var obstacle: Obstacle
    override var center: CGPoint {
        get { obstacle.center }
        set { obstacle.center = newValue }
    }
    override var angle: CGFloat {
        get { obstacle.angle }
        set { obstacle.angle = newValue }
    }
    var collisionCount: Int = 0
    var type: ObjectType.ObstacleType {
        obstacle.type
    }
    var size: CGFloat {
        obstacle.size
    }
    
    init(obstacle: Obstacle) {
        self.obstacle = obstacle
        super.init(center: obstacle.center, velocity: Constants.defaultObstacleVelocity, mass: Constants.defaultObstacleMass, isStatic: true)
    }
    
    // factory
    static func createGameObstacle(from obstacle: Obstacle, velocity: CGVector = Constants.defaultObstacleVelocity, mass: CGFloat = Constants.defaultObstacleMass) -> GameObstacle {
        switch obstacle.type {
        case .rectangle:
            guard let shape = obstacle.shape as? RectangleShape else {
                fatalError("Rectangle should only have rectangular shape")
            }
            return GameRectangleObstacle(obstacle: obstacle, width: shape.width, height: shape.height)
        case .circle:
            // TODO: intantiate respective obstacle types
            guard let shape = obstacle.shape as? RectangleShape else {
                fatalError("Rectangle should only have rectangular shape")
            }
            return GameRectangleObstacle(obstacle: obstacle, width: shape.width, height: shape.height)
        case .triangle:
            guard let shape = obstacle.shape as? RectangleShape else {
                fatalError("Rectangle should only have rectangular shape")
            }
            return GameRectangleObstacle(obstacle: obstacle, width: shape.width, height: shape.height)
        }
    }
}

class GameRectangleObstacle: GameObstacle, RectangularPhysicsObject {
    func isColliding(with object: PhysicsObject) -> Bool {
        return false
    }
    
    var rectangleShape: RectangleShape {
        guard let shape = obstacle.shape as? RectangleShape else {
            fatalError("GameRectangleObstacle can only be initialized with a RectangleShape")
        }
        return shape
    }
    var width: CGFloat {
        rectangleShape.width
    }
    var height: CGFloat {
        rectangleShape.height
    }
    
    init(obstacle: Obstacle, width: CGFloat = Constants.rectangleObstacleSize * Constants.rectangleWidthToHeightRatio, height: CGFloat = Constants.rectangleObstacleSize) {
        let shape = RectangleShape(center: obstacle.center, angle: obstacle.angle, width: width, height: height)
        obstacle.shape = shape
        super.init(obstacle: obstacle)
    }
}
