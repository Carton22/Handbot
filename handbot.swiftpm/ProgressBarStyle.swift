//
//  ProgressBarStyle.swift
//  handbot
//
//  Created by carton22 on 2023/4/16.
//

import Foundation
import SwiftUI

struct MyProgressBarStyle: ProgressViewStyle {
    var progressColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(height: 10)
                
                Rectangle()
                    .foregroundColor(progressColor)
                    .frame(width: (configuration.fractionCompleted ?? 20) * UIScreen.main.bounds.width, height: 10)
                    .animation(.linear)
            }
            .cornerRadius(5.0)
        }
    }
}

