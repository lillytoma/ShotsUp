//
//  ShotsUpApp.swift
//  ShotsUp
//
//  Created by Lilly Toma on 1/23/25.
//

import SwiftUI
import AVFoundation

@main
struct ShotsUpApp: App {
    @State private var audioPlayer:AVAudioPlayer?
    var body: some Scene {
        WindowGroup {
            HomePage()
                .onAppear(){
                    audioPlayerFunc()
                }
        }
    }
    private func audioPlayerFunc() {
        if let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "m4a"){
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                // couldn't load file :(
                print("Error \(error)")
            }
        }
    }
}
