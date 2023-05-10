//
//  ScoreView.swift
//  handbot
//
//  Created by carton22 on 2023/4/16.
//

import Foundation
import SwiftUI

final class ScoreModel: ObservableObject {
    static let shared = ScoreModel()
    
    @Published var score: Int = 0
    
    func reset() {
            score = 0
        }
}
