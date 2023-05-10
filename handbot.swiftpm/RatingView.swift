//
//  RatingView.swift
//  handbot
//
//  Created by carton22 on 2023/4/14.
//

import SwiftUI

struct RatingView: View {
    @State private var rating1 = 3
    @State private var rating2 = 5
    @State private var rating3 = 5
    
    let likeRange = ["dislike","not bad","so so","good","fantastic"]
    @State private var selectedLike = "so so"
    
    let ratingRange = 0...10
    
    let emotions = ["😡", "😢", "😃", "😘", "😎"]
    @State private var selectedEmotion = "😃"
    
    
    var body: some View {
            VStack {
                Text("How much do you think this AI-created song deserves?")
                    .foregroundColor(.white)
                
                Picker("", selection: $rating2) {
                    ForEach(ratingRange, id: \.self) { number in
                        Text("\(number)")
                            .font(.headline)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
                
                Text("What are the Human-like qualities of this AI-created song?")
                    .foregroundColor(.white)
                
                Picker("", selection: $rating3) {
                    ForEach(ratingRange, id: \.self) { number in
                        Text("\(number)")
                            .font(.headline)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
                
                Text("How much do you like this AI-created song?")
                    .foregroundColor(.white)
                
                Picker(selection: $selectedLike, label: Text("")) {
                    ForEach(likeRange, id: \.self) { like in
                        Text(like)
                            .font(.headline)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 350)
                Text("Emotional impact of this AI-created song")
                    .foregroundColor(.white)
                
                Picker(selection: $selectedEmotion, label: Text("")) {
                    ForEach(emotions, id: \.self) { emotion in
                        Text(emotion)
                            .font(.largeTitle)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
                
            }
    }
}
