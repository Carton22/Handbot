//
//  ScoreAchievedView.swift
//  handbot
//
//  Created by carton22 on 2023/4/16.
//

import Foundation
import SwiftUI

struct ScoreAchievedView: View {
    @Binding var isScoreAchieved: Bool
    
    
    var body: some View {
        ZStack{
            Color.darkBackground.ignoresSafeArea()
            GeometryReader{geometry in
                VStack {
                    Text("🎉")
                        .font(.largeTitle)
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                        .padding(.top)
                    Text("Congratulations! Every edit counts! You have done a good job in the interaction with AI-generated context!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(action:{
                        isScoreAchieved = false
                        ScoreModel.shared.reset()
                    }){
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
                .padding()
            }
        }
    }
}

