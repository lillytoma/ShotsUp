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
                    ZStack{

                        //set up a naviagtion back to the homescreen when the timer ends
                            SpriteView(scene: scene) //calling scene which calls GameScene
                                .frame(width: width, height: height)
                                .padding(EdgeInsets(top: -45, leading: -45, bottom: -45, trailing: -45))
                                .clipShape(Circle())
                        
                            VStack{
                                HStack{
                                    Spacer()
                                Text("Score: \(GameState.numberPointsEarned)")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .padding()
                                    .bold()
                            }
                                Spacer()
                            

                        }
                        withAnimation(.easeOut(duration: 3.0).delay(2.0)){
                            HStack{
                                Text("Hit")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                Text("\(GameState.numberOfBallsToHit - GameState.hitCounter) \(GameState.colorName)")
                                    .foregroundStyle(Color(GameState.actualColor))
                                    .bold()
                                    .font(.title)
                                Text("balls!")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                            }
                                    .frame(width: 300, height: 200)
                                    .padding(.bottom, 400)
                        }
                            
                            Text("\(GameState.CountDownTime)")
                            .font(.custom("", size: 70))
                                .foregroundStyle(.white)
                                .padding(.bottom, 530)
                                .bold()
                            
                        Button{
                            
                            if GameState.gameEnded == true{
                                GameState.ResetGameState()
                            }
                            
                            
                            
                        }label:{
                            
                            Text("Play Again")
                            
                                .font(.largeTitle)
                            
                                .bold()
                            
                                .foregroundStyle(!GameState.gameEnded ? .clear : .white)
                            
                            
                            
                        }
                        
                        }
                    
                    }
                }
        }
    
    }

#Preview {
    
    ContentView()
    
}
