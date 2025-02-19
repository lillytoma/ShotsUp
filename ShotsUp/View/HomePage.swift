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
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 10)
                    
                    Image("HomePageBall")
                        .padding(.top, 20)
                    Spacer()
                        NavigationLink(destination: ContentView()) {
                            Image("PlayButton")
                                .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
