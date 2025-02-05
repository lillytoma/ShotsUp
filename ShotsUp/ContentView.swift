//
//  ContentView.swift
//  ShotsUp
//
//  Created by Lilly Toma on 1/23/25.
//

import SwiftUI
import SpriteKit


struct Window: Shape {
    let size: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        
        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        path.addRoundedRect(in: CGRect(origin: origin, size: size), cornerSize: size)
        return path
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
        ZStack {
            Color.black.ignoresSafeArea()
            SpriteView(scene: scene) //calling scene which calls GameScene
                .frame(width: width, height: height)

            Rectangle()
                .foregroundColor(Color.black.opacity(1))
                .mask(Window(size: CGSize(width: 250, height: 250)).fill(style: FillStyle(eoFill: true)))
            
            RoundedRectangle(cornerRadius: 150).stroke(Color.white, lineWidth: 3)
                .frame(width: 250, height: 250)
            
            RoundedRectangle(cornerRadius: 150).stroke(Color.white, lineWidth: 0.5)
                .frame(width: 160, height: 160)
        }
    }
}

class GameScene: SKScene{ //this view deos not show up until it gets called in content view
    //creating a physics body
    
    
    
    //making different colored balls, it is an array that will consists of UIColors
    let ballColors: [UIColor] = [.blue, .orange, .yellow, .red, .green, .purple]
    var visibleBalls: [SKNode] = []
    //let background = SKSpriteNode(imageNamed: "J8L2")
    //background.size = CGSize(width: 10, height: 10)
    
    //UIScreen will change size depending on the device
    var boundWidth = UIScreen.main.bounds.width
    var boundHeight = UIScreen.main.bounds.height
    
    var dt: TimeInterval = 0.0 //DeltaTime
    var pt: TimeInterval = 0.0 //PreviousTime
    var at: TimeInterval = 0.0
    
    //self. is just pointing to the GameScene itself
    override func didMove(to view: SKView){
        
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
        
        let xPos = -width + 25...width - 25
        let yPos = -height + 25...height - 25
        
        groundborder.physicsBody = SKPhysicsBody(edgeChainFrom: groundborder.path!)
        groundborder.physicsBody!.categoryBitMask = 0b0001
        groundborder.physicsBody!.collisionBitMask = 0b0001
        groundborder.physicsBody!.contactTestBitMask = 0b0001
        groundborder.physicsBody!.affectedByGravity = false
        groundborder.physicsBody!.pinned = true    
        groundborder.physicsBody!.isDynamic = false
        
        addChild(groundborder)
        
        for _ in 0...50{
            
            let ball = SKShapeNode(circleOfRadius: 15.0)
            ball.name = "Ball"
            ball.position = CGPoint(x: Int.random(in: xPos), y: Int.random(in: yPos))
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 18)
            ball.strokeColor = .white
           // ball.glowWidth = 5
            ball.physicsBody!.usesPreciseCollisionDetection = true
            ball.physicsBody!.isDynamic = false
            ball.physicsBody!.affectedByGravity = false
            //ball.physicsBody!.mass = 0
            ball.physicsBody!.linearDamping = 0
            ball.physicsBody!.restitution = 0.2
            ball.physicsBody!.categoryBitMask = 0b0001
            ball.physicsBody!.collisionBitMask = 0b0001
            ball.physicsBody!.contactTestBitMask = 0b0001

            
            let color = ballColors.randomElement() ?? .blue//?? are optionals, meaning, it checks if it actually has it or else it will go to a default which you will have to set
            let _: UIColor = .white
        
            
            ball.fillColor = color
            //ball.strokeColor = .white
            //addChild(background)
            addChild(ball)


            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("looking")
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        for node in self.nodes(at: location){ //looking for all nodes at the place the click was init
            if node.name == "Ball" { //if the ball name is == Ball
                node.removeFromParent() //parent is the game scene
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) { //this function itself is a loop
        dt = pt - currentTime
        pt = currentTime
        FindBallInLens()
        if at > 1{
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
}

#Preview {
    
    ContentView()
    
}
