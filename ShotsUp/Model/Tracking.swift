//
//  Tracking.swift
//  ShotsUp
//
//  Created by Clyde Jackson on 2/5/25.
//

import SwiftUI
import SpriteKit
import Observation


//color selected

// number needed of the colors selected

@Observable class Player{ //includes the high score
    
}

let ballColors: [UIColor] = [.blue, .orange, .yellow, .red, .green, .purple]

@Observable class CurrentGameState{ //count down time, rounds, color selected, how many needed
    var CountDownTime: Int = 30
    var currentRound = 0
    var gameEnded = false
    var highestRandomNumber: Int = 0
    var numberPointsEarned: Int = 0
    var colorName: String = "red"
    var actualColor: UIColor = .red
    var numberOfBallsToHit: Int = .random(in: 1...2)
    
    var hitCounter: Int = 0
    
    func InitRound(){
        
    }
    
    func ResetGameState(){
        currentRound = 0
        CountDownTime = 30
        hitCounter = 0
        numberOfBallsToHit = .random(in: 1...2)
        numberPointsEarned = 0
        highestRandomNumber = 0
        
        actualColor = ballColors.randomElement() ?? .blue
        colorName = GetColorName(color: actualColor)
        gameEnded = false
    }
    
    func GetColorName(color: UIColor) -> String{
        switch color{
        case ballColors[0]:
            return "blue"
        case ballColors[1]:
            return "orange"
        case ballColors[2]:
            return "yellow"
        case ballColors[3]:
            return "red"
        case ballColors[4]:
            return "green"
        case ballColors[5]:
            return "purple"
        default:
            return "not found"
        }
    }
}





extension GameScene{
    func FindBallInLens(){
        for ball in self.children {
            if ball.name == ("Ball"){
                if (ball.position.x.magnitude < 110) && (ball.position.y.magnitude < 110){ //check if the ball is within our scope
                    guard let foundball = ball as? SKShapeNode else {return}
                    _ = GetColorName(color: foundball.fillColor)
                    BallEntered(node: ball)
                    //print(colorFound)
                }
                else{ //if it is not in our scope, do nothing
                    BallLeft(node: ball)
                }
            }
        }
       //print(visibleBalls.count)
        
    }
    
    func GetColorName(color: UIColor) -> String{
        switch color{
        case ballColors[0]:
            return "blue"
        case ballColors[1]:
            return "orange"
        case ballColors[2]:
            return "yellow"
        case ballColors[3]:
            return "red"
        case ballColors[4]:
            return "green"
        case ballColors[5]:
            return "purple"
        default:
            return "not found"
        }
    }
    
    func BallEntered(node: SKNode){
        let searchBall = visibleBalls.filter{$0 == node}
        if searchBall.isEmpty{
            visibleBalls.append(node)
        }
        else{
            return
        }
    }
    
    func BallLeft(node: SKNode){
        visibleBalls.removeAll{$0 == node}
    
    }

}
