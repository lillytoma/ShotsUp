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
            ZStack{
                
                Color.black.ignoresSafeArea()
                
                
                Image("HomePageBall")
                    .frame(width: 200, height: 200)
                
                VStack{
                    HStack{
                        NavigationLink(destination: InstructionPage()){
                            Image("InstButton")
                                .padding(.leading, 250)


                        }
                    }
                    Image("BallisticBlobsText")
                        .padding(.bottom, 450)
                    
                        NavigationLink(destination: ContentView()) {
                            Image("PlayButton")
                                .padding(.bottom, 50)
                        }
                    
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
