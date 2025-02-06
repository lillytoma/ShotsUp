//
//  Tracking.swift
//  ShotsUp
//
//  Created by Clyde Jackson on 2/5/25.
//

import SwiftUI
import SpriteKit

extension GameScene{
    func FindBallInLens(){
        for ball in self.children {
            if ball.name == ("Ball"){
                if (ball.position.x.magnitude < 80) && (ball.position.y.magnitude < 80){ //check if the ball is within our scope
                    guard let foundball = ball as? SKShapeNode else {return}
                    let colorFound = GetColorName(color: foundball.fillColor)
                    BallEntered(node: ball)
                    //print(colorFound)
                }
                else{ //if it is not in our scop, do nothing
                    BallLeft(node: ball)
                }
            }
        }
       // print(visibleBalls.count)
        
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
