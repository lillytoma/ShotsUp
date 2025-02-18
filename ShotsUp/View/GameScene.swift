//
//  GameScene.swift
//  ShotsUp
//
//  Created by Lilly Toma on 2/17/25.
//
import SwiftUI
import SpriteKit
import Observation

struct Window: Shape {
    let size: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        
        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        path.addRoundedRect(in: CGRect(origin: origin, size: size), cornerSize: size)
        return path
    }
}

class Haptics {
    static let instance = Haptics()
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
    }
}


//class Ball: SKShapeNode{
//    let var padding = 30;
//    
//    override func contains(_ point: CGPoint) -> Bool {
//        
//    }
//}

class GameScene: SKScene{ //this view deos not show up until it gets called in content view
    //creating a physics body
    
    let myCircle = SKShapeNode(circleOfRadius: UIScreen.main.bounds.width/2 - 45)
    var count = 0
    
    //making different colored balls, it is an array that will consists of UIColors
    let ballColors: [UIColor] = [.blue, .orange, .yellow, .red, .green, .purple]
    var visibleBalls: [SKNode] = []
    
    
    var color: UIColor = .blue
    //let background = SKSpriteNode(imageNamed: "J8L2")
    //background.size = CGSize(width: 10, height: 10)
    
    //UIScreen will change size depending on the device
    var boundWidth = UIScreen.main.bounds.width
    var boundHeight = UIScreen.main.bounds.height
    
    var dt: TimeInterval = 0.0 //DeltaTime
    var pt: TimeInterval = 0.0 //PreviousTime
    var at: TimeInterval = 0.0
    
    
    var dictionary: [SKNode] = []
    
    //self. is just pointing to the GameScene itself
    override func didMove(to view: SKView){
        
        myCircle.strokeColor = .white
        myCircle.lineWidth = 15
        
        
        if(GameState.gameEnded != false && GameState.CountDownTime > 0){
            color = ballColors.randomElement() ?? .blue //assigns a random color to color
            GameState.actualColor = color // get a random color
            GameState.colorName = GetColorName(color: color) //set the random color in a string so we can display
 //         print(GetColorName(color: color)) //prints out the actual string, console
        }
        
        
        let width = Int(boundWidth / 2)
        let height = Int(boundHeight / 2)
        
        var border = [CGPoint(x: -width , y: -height), //width / 2,
                      CGPoint(x:  -width , y: height),
                      CGPoint(x:  width , y: height),
                      CGPoint(x: width , y: -height),
                      CGPoint(x: -width , y: -height),
                      
        ]
        let groundborder = SKShapeNode(splinePoints: &border, count: border.count)
        groundborder.lineWidth = 5
        
        groundborder.physicsBody = SKPhysicsBody(edgeChainFrom: groundborder.path!)
        groundborder.physicsBody!.categoryBitMask = 0b0001
        groundborder.physicsBody!.collisionBitMask = 0b0001
        groundborder.physicsBody!.contactTestBitMask = 0b0001
        groundborder.physicsBody!.affectedByGravity = false
        groundborder.physicsBody!.pinned = true
        groundborder.physicsBody!.isDynamic = false
        
        addChild(groundborder)
        
        for _ in 0...50{
            let ball = CreateBall(SpecifiedColor: .clear)
            addChild(ball)
        }
        
        
        addChild(myCircle)
        
    }
    
    override func update(_ currentTime: TimeInterval) { //this function itself is a loop
        dt = pt - currentTime
        pt = currentTime
        FindBallInLens()
        myCircle.strokeColor = GameState.actualColor

        if at > 1{
            if GameState.CountDownTime > 0 {
                GameState.CountDownTime -= 1
            }
            else if GameState.gameEnded == false{
                GameState.gameEnded = true
            }
            at = 0.0
            for ball in self.children{
                if ball.name == "Ball"{
                    ball.physicsBody!.applyImpulse(CGVector(dx: Int.random(in: -30...30), dy: Int.random(in: -30...30)))
                }
            }
        }else{
            at += abs(dt)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch:UITouch = touches.first!
        
        let location = touch.location(in: self)
        
        for ball in self.nodes(at: location){ //looking for all nodes at the place the click was init
            if ball.name == "Ball" { //if the ball name is == Ball
                
                guard let tappedBall = ball as? SKShapeNode else {return}
                if(GameState.gameEnded == false){
                    if(tappedBall.fillColor == GameState.actualColor){
                        Haptics.instance.impact(style: .heavy)
                        
                        GameState.hitCounter += 1
                        GameState.numberPointsEarned += 5
                        if(GameState.numberOfBallsToHit == GameState.hitCounter && GameState.CountDownTime > 0){
                            GameState.CountDownTime += 15
                            GameState.hitCounter = 0
                            GameState.actualColor = ballColors.randomElement() ?? .blue
                            GameState.colorName = GetColorName(color:GameState.actualColor)
                            GameState.numberOfBallsToHit = Int.random(in: 3...5) + 1
                            generateBall()
                        }
                        
                    }
                    else{
                        if(GameState.hitCounter > 0 && GameState.numberPointsEarned > 0){
                            GameState.hitCounter -= 1
                            GameState.numberPointsEarned -= 5
                        }
                    }
                    
                    //print(tappedColor)
                    print(GameState.hitCounter)
                    ball.removeFromParent() //parent is the game scene
                    
                }

            }
            
        }
    }
    
    func CreateBall(SpecifiedColor: UIColor) -> SKShapeNode{
        let width = Int(boundWidth / 2)
        let height = Int(boundHeight / 2)
        let color: UIColor
        
        let xPos = -width + 25...width - 25
        let yPos = -height + 25...height - 25
        
        let ball = SKShapeNode(circleOfRadius: 17.0)
        ball.name = "Ball"
        ball.position = CGPoint(x: Int.random(in: xPos), y: Int.random(in: yPos))
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 23)
        ball.strokeColor = .clear
        ball.physicsBody!.usesPreciseCollisionDetection = true
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.restitution = 0
        ball.physicsBody!.categoryBitMask = 0b0001
        ball.physicsBody!.collisionBitMask = 0b0001
        ball.physicsBody!.contactTestBitMask = 0b0001
        
        
        if SpecifiedColor != .clear{
            color = SpecifiedColor
        } else{
            color = ballColors.randomElement() ?? .blue
        }
        //?? are optionals, meaning, it checks if it actually has it or else it will go to a default which you will have to set
        let _: UIColor = .white
        
        
        ball.fillColor = color
        
        return ball
    }
}
