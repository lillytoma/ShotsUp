//
//  BallGenerator.swift
//  ShotsUp
//
//  Created by Lilly Toma on 2/12/25.
//

import SwiftUI
import SpriteKit
import Observation

extension GameScene{
    
    func BallsInScene() -> Int{
        var ballCount: [SKShapeNode] = []
        for ball in self.children{
                guard let ballNode = ball as? SKShapeNode else {continue}
                if ballNode.name == "Ball" && ballNode.fillColor == GameState.actualColor{
                    ballCount.append(ballNode)
                }
                
            }
        return ballCount.count
    }
    
    func generateBall(){ //get the color of the ball selected, get the amount that was selected
        let ballCount = self.BallsInScene()
        if ballCount < GameState.numberOfBallsToHit{
            let difference = (GameState.numberOfBallsToHit - ballCount) + GameState.numberOfBallsToHit
            for _ in 1...difference{
                let moreBalls = CreateBall(SpecifiedColor: GameState.actualColor)
                addChild(moreBalls)
                
            }
        }else if(ballCount < 5){
            for _ in 1...GameState.numberOfBallsToHit + 5{
                let moreBalls = CreateBall(SpecifiedColor: GameState.actualColor)
                addChild(moreBalls)
            }
        }
    }
}
