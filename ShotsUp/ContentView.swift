//
//  ContentView.swift
//  ShotsUp
//
//  Created by Lilly Toma on 1/23/25.
//

import SwiftUI

import SpriteKit



class GameScene: SKScene{

let ballCount = 50

let boundWidth = UIScreen.main.bounds.width

let boundHeight = UIScreen.main.bounds.height

let colors: [UIColor] = [.red,.green,.blue,.yellow,.orange]





override func didMove(to view: SKView) {



let cropper = SKCropNode()

cropper.scene?.size = CGSize(width: boundWidth, height: boundHeight)



for _ in 1...ballCount{

let xRange = 15...boundWidth - 15

let yRange = 15...boundHeight - 15

let xPos = CGFloat.random(in: xRange)

let yPos = CGFloat.random(in: yRange)

let color = colors.randomElement() ?? .red



//let ball = SKSpriteNode(color: colors.randomElement() ?? .red, size: CGSize(width: 35, height: 35))

let ball = SKShapeNode(circleOfRadius: 10)

ball.fillColor = color

ball.strokeColor = color

ball.position = CGPoint(x: xPos, y: yPos)



addChild(ball)

}

let sheet = SKSpriteNode()

sheet.size = CGSize(width: boundWidth*2, height: boundHeight*2)

sheet.color = .black





cropper.addChild(sheet)



}



override func update(_ currentTime: TimeInterval) {



}



}



struct ContentView: View {



var scene: SKScene{

let scene = GameScene()

scene.size = CGSize(width: scene.boundWidth, height: scene.boundHeight)

scene.scaleMode = .fill



return scene

}



var body: some View {

VStack {

SpriteView(scene: scene)

}

.padding()

}

}



#Preview {

ContentView()

}
