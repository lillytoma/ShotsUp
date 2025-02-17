//
//  ContentView.swift
//  ShotsUp
//
//  Created by Lilly Toma on 1/23/25.
//

import SwiftUI
import SpriteKit
import Observation

var GameState = CurrentGameState()

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
        
        
        color = ballColors.randomElement() ?? .blue //assigns a random color to color
        
        GameState.actualColor = color // get a random color
        GameState.colorName = GetColorName(color: color) //set the random color in a string so we can display
        
        
        print(GetColorName(color: color)) //prints out the actual string
        
        
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
    
    
    
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        print("looking")
    //        guard let touch = touches.first else {return}
    //
    //        let location = touch.location(in: self)
    //        let touchedNodes = self.nodes(at: location)
    //
    //        for node in touchedNodes{
    //            guard node is SKShapeNode else {return}
    //            if node.name == "Ball"{
    //                node.removeFromParent()
    //            }
    //        }
    //        }
    //
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches {
    //            let location = touch.location(in: self)
    //            let touchedNode = self.atPoint(location)
    //            if touchedNode.name == "Ball"{
    //                touchedNode.removeFromParent()
    //                break;
    //            }
    //        }
    //    }
    
    override func update(_ currentTime: TimeInterval) { //this function itself is a loop
        dt = pt - currentTime
        pt = currentTime
        FindBallInLens()
        
        if at > 1{
            if GameState.CountDownTime > 0 {
                GameState.CountDownTime -= 1
            }
            else{
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
    
    func clicked(shape: SKShapeNode){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch:UITouch = touches.first!
        
        let location = touch.location(in: self)
        
        for ball in self.nodes(at: location){ //looking for all nodes at the place the click was init
            if ball.name == "Ball" { //if the ball name is == Ball
                Haptics.instance.impact(style: .heavy)

                guard let tappedBall = ball as? SKShapeNode else {return}
                

                if(tappedBall.fillColor == GameState.actualColor){
                    GameState.hitCounter += 1
                    GameState.numberPointsEarned += 5
                    if(GameState.numberOfBallsToHit == GameState.hitCounter && GameState.CountDownTime > 0){
                        GameState.CountDownTime += 15
                        GameState.hitCounter = 0
                        GameState.actualColor = ballColors.randomElement() ?? .blue
                        GameState.colorName = GetColorName(color:GameState.actualColor)
                        GameState.numberOfBallsToHit = Int.random(in: 5...10)
                    }
                }
                else{
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    
                    let shake = SKAction.shake(duration: 0.3, amplitudeX: 50, amplitudeY: 50)
                    ball.run(shake)
                }
                //print(tappedColor)
                print(GameState.hitCounter)
                ball.removeFromParent() //parent is the game scene
                
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
        // ball.glowWidth = 5
        ball.physicsBody!.usesPreciseCollisionDetection = true
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.affectedByGravity = false
        //ball.physicsBody!.mass = 0
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
//    func impact(style: UIFeedbackGenerator.FeedbackStyle){
//}
extension SKAction{
    class func shake(duration: CGFloat, amplitudeX: Int = 3, amplitudeY: Int = 3) -> SKAction{
        let numberOfShakes = duration / 0.015 / 2.0
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes){
            let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            let forward = SKAction.moveBy(x: dx, y: dy, duration: 0.015)
            let reverse = forward.reversed()
            actionsArray.append(forward)
            actionsArray.append(reverse)
        }
        return SKAction.sequence(actionsArray)
    }
}


struct ContentView: View {
    private var width = UIScreen.main.bounds.width
    private var height = UIScreen.main.bounds.height
    
    var scene: SKScene{ //making a scene so we can make GameScene visible
        let scene = GameScene() //calling gamescene, now the gamescene is called "scene"
        scene.backgroundColor = UIColor(Color.black)
        
        //scene. is the accessor
        scene.size = CGSize(width: scene.boundWidth, height: scene.boundHeight)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        return scene
        
    }
    
    
    var body: some View {
            ZStack{
                Color.black.ignoresSafeArea()
                 
                HStack{
                    // VStack {
                    ZStack{
                        //NavigationLink("", destination: HomePage(), isActive: $GameState.gameEnded)
                        //set up a naviagtion back to the homescreen when the timer ends
                            SpriteView(scene: scene) //calling scene which calls GameScene
                                .frame(width: width, height: height)
                                .padding(EdgeInsets(top: -45, leading: -45, bottom: -45, trailing: -45))
                                .clipShape(Circle())
                        HStack{
                            
                            Text("\(GameState.hitCounter)/\(GameState.numberOfBallsToHit)")
                                .padding(.bottom, 500)
                            Text("Points Earned: \(GameState.numberPointsEarned)")
                                .padding(.bottom, 500)
                                
                        }
                        withAnimation(.easeOut(duration: 3.0).delay(2.0)){
                            Text("Hit \(GameState.numberOfBallsToHit) \(GameState.colorName) balls for points!")
                                    .frame(width: 300, height: 200)
                                    .padding(.bottom, 400)
                                    .foregroundStyle(.white)
                        }
                            
                            Text("\(GameState.CountDownTime)")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .padding(.bottom, 600)
                            
                        
                        
                        }
                        
                        //            Rectangle()
                        //                .foregroundColor(Color.black.opacity(1))
                        //                .mask(Window(size: CGSize(width: 250, height: 250)).fill(style: FillStyle(eoFill: true)))
                        //
                        //            RoundedRectangle(cornerRadius: 150).stroke(Color.white, lineWidth: 3)
                        //                .frame(width: 250, height: 250)
                        //
                        //            RoundedRectangle(cornerRadius: 150).stroke(Color.white, lineWidth: 0.5)
                        //                .frame(width: 160, height: 160)
                    }
                    //  }
                }
        }
    }

#Preview {
    
    ContentView()
    
}
