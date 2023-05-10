//
//  TextView.swift
//  handbot
//
//  Created by carton22 on 2023/4/12.
//

import SwiftUI
import UIKit

struct Answer: Decodable {
    let id: Int
    let answer: String
}


struct TextView: View {
    @ObservedObject var scoreModel = ScoreModel.shared
    @State private var strings: [String]
    @State private var currentIndex = 0
    @State private var textgenfinish = false
    @State private var textFields: [String] = []
    @State private var isClicked = Array(repeating: false, count: 200)
    @State private var isPrinting = false
    @State private var timer = Timer.publish(every: Double.random(in: 0.07..<0.13), on: .main, in: .common).autoconnect()
    @State private var showingAlert = false
    @State private var isEditing = false
    @State private var isScoreAchieved = false
    @State private var dragAmount = CGSize.zero
    
    let columns = Array(repeating: GridItem(.flexible()), count: 8)
       
    let screenWidth = UIScreen.main.bounds.width
    
    init() {
        guard let url = Bundle.main.url(forResource: "QandA", withExtension: "json") else {
            fatalError("Failed to locate JSON file")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let answers = try JSONDecoder().decode([Answer].self, from: data)
            let printAnswer = answers[Int.random(in: 0...10)].answer
            strings = printAnswer.components(separatedBy: " ")
        } catch {
            fatalError("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        @ObservedObject var scoreModel = ScoreModel.shared
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            VStack {
                if isPrinting{
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach(0..<textFields.count, id: \.self) { index in
                                let len = textFields[index].count * 13
                                TextField("", text: $textFields[index], onCommit: {
                                    if textgenfinish {
                                        scoreModel.score += 5
                                    }
                                })
                                .font(.system(.body, design: .serif))
                                .foregroundColor(isClicked[index] ? Color.blue : Color.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .frame(width: CGFloat(len), height: 40)
                                .padding(.horizontal, 4)
                                .fixedSize(horizontal: false, vertical: true)
                                .offset(dragAmount)
                                .animation(.default.delay(Double(index) / 20), value: dragAmount)
                                .onTapGesture {
                                    UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                                    if textgenfinish{
                                        isClicked[index].toggle()
                                        if isClicked[index]{
                                            scoreModel.score += 5
                                        }
                                    } else {
                                        showingAlert = true
                                    }
                                }
                                .disabled(isEditing && textFields[index].isEmpty)
                                .disabled(false)
                                .alert(isPresented: $showingAlert) { // 3
                                    Alert( // 4
                                        title: Text("Please edit until stop generating!"), // 标题
                                        message: Text("click the word👆\ndrag the word around\nedit the word directly⌨️"), // 消息内容
                                        dismissButton: .cancel(Text("Cancel").foregroundColor(.orange))
                                    )
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { dragAmount = $0.translation }
                                        .onEnded { _ in
                                            dragAmount = .zero
                                        }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .onAppear {
                            if currentIndex == 0 {
                                textFields = Array(repeating: "", count: strings.count)
                            }
                        }
                        .onReceive(timer) { _ in
                            if currentIndex < strings.count {
                                textFields[currentIndex] = strings[currentIndex]
                                currentIndex += 1
                            } else {
                                timer.upstream.connect().cancel()
                                textgenfinish = true
                                showingAlert = false
                            }
                        }
                        .onReceive(ScoreModel.shared.$score) { score in
                            if score >= 90 {
                                isScoreAchieved = true
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                            .shadow(radius: 3)
                    )
                    .clipped()
                    
                    
                }
                
                Button(action:{
                    currentIndex = 0
                    textFields = Array(repeating: "", count: strings.count)
                    isClicked = Array(repeating: false, count: strings.count)
                    isPrinting.toggle()
                    
                    if !isPrinting{
                        guard let url = Bundle.main.url(forResource: "QandA", withExtension: "json") else {
                            fatalError("Failed to locate JSON file")
                        }
                        
                        do {
                            let data = try Data(contentsOf: url)
                            let answers = try JSONDecoder().decode([Answer].self, from: data)
                            let printAnswer = answers[Int.random(in: 0...10)].answer
                            strings = printAnswer.components(separatedBy: " ")
                        } catch {
                            fatalError("Failed to decode JSON: \(error.localizedDescription)")
                        }
                    }else{
                        textgenfinish = false
                    }
                }){
                    
                    Text(isPrinting ? "Clear" : "Generate Text")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isPrinting ? Color.green : Color.blue)
                        .cornerRadius(20)
                }
                
                ProgressView(value: Double(scoreModel.score) / 100.0)
                    .progressViewStyle(MyProgressBarStyle(progressColor: Color.blue))
                    .padding(.horizontal)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $isScoreAchieved) {
                ScoreAchievedView(isScoreAchieved: $isScoreAchieved)
            }
        }
    }
    
    
}




struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
