//
//  HomePage.swift
//  ShotsUp
//
//  Created by Lilly Toma on 2/10/25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack{
                VStack{
                    HStack{
                        Spacer()
                        
                        NavigationLink(destination: InstructionPage()){
                            Image("InstButton")
                        }
                        
                    }
                    Image("BallisticBlobsText")
                    
                    Image("HomePageBall")
                    Spacer()
                        NavigationLink(destination: ContentView()) {
                            Image("PlayButton")
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
