//
//  ContentView.swift
//  ShotsUp
//
//  Created by Lilly Toma on 1/23/25.
//

import SwiftUI
import SpriteKit
    
struct ContentView: View {
    private var width = UIScreen.main.bounds.width
    private var height = UIScreen.main.bounds.height
    
    var scene: SKScene{ //making a scene so we can make GameScene visible
        
        let scene = GameScene() //calling gamescene, now the gamescene is called "scene"
        //scene. is the accessor
        scene.size = CGSize(width: scene.boundWidth, height: scene.boundHeight)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        return scene

    }
    
    
    var body: some View {
        ZStack {
            
           SpriteView(scene: scene) //calling scene which calls GameScene
                .frame(width: width, height: height)
            
            Rectangle()
                .frame(width: width, height: height)
                //.overlay{
                    //TransparentView()
                //}
            }
        
        //TransparentView.makeClearHole(rect: CGRect(x: 100, y: 100, width: 200, height: 200))
            
        }
    }

class TransparentView: UIView{
    func makeClearHole(rect: CGRect){
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.white.cgColor
        
        let pathToOverlay = UIBezierPath(rect: self.bounds)
        pathToOverlay.append(UIBezierPath(rect: rect))
        pathToOverlay.usesEvenOddFillRule = true
        
        self.layer.mask = maskLayer
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
