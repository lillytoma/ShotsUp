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
                .mask(Window(size: CGSize(width: 200, height: 200)).fill(style: FillStyle(eoFill: true)))
            
            RoundedRectangle(cornerRadius: 150).stroke(Color.white, lineWidth: 3)
                .frame(width: 200, height: 200)
            
        }
    }
}

class GameScene: SKScene{ //this view deos not show up until it gets called in content view
    
    //making different colored balls, it is an array that will consists of UIColors
    let ballColors: [UIColor] = [.blue, .orange, .yellow, .red, .green, .purple]
    
    
    //UIScreen will change size depending on the device
    var boundWidth = UIScreen.main.bounds.width
    var boundHeight = UIScreen.main.bounds.height
    
    //self. is just pointing to the GameScene itself
    override func didMove(to view: SKView){
    
        let width = Int(boundWidth / 2)
        let height = Int(boundHeight / 2)
        
        for _ in 0...50{
            
            let ball = SKShapeNode(circleOfRadius: 15.0)
            
            ball.position = CGPoint(x: Int.random(in: -width...width), y: Int.random(in: -height...height))
            
            let color = ballColors.randomElement() ?? .blue//?? are optionals, meaning, it checks if it actually has it or else it will go to a default which you will have to set
            let stroke: UIColor = .clear
            
            ball.fillColor = color
            ball.strokeColor = stroke
            
            addChild(ball)
        }
    }
}

#Preview {
    
    ContentView()
    
}
