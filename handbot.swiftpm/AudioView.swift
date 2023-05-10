import SwiftUI
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    @Published var playbackTime: TimeInterval?
    private var player: AVAudioPlayer!
    
    func playAudio(currPlay: Int) {
        if let url = Bundle.main.url(forResource: "music\(currPlay)", withExtension: ".wav") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.delegate = self
                if let playbackTime = playbackTime {
                    player.currentTime = playbackTime
                } else {
                    player.currentTime = 0
                }
                
                player.play()
                isPlaying = true
                
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
    
    func pauseAudio() {
        player.pause()
        isPlaying = false
        playbackTime = player.currentTime
    }
    
    func stopAudio() {
        player.stop()
        isPlaying = false
        playbackTime = nil
    }
    
    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        playbackTime = nil
    }
}


struct AudioView: View {
    @ObservedObject var scoreModel = ScoreModel.shared
    @State private var showButton = true
    @State private var playcontrol = false
    @State private var isLoading = false
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var addnotes = false
    @State private var message = ""
    @State private var wordCount: Int = 0
    @State private var musicinit = false
    @State private var isScoreAchieved3 = false
    
    @State var currPlay = 0
    
    var body: some View {
        ZStack{
            Color.darkBackground.ignoresSafeArea()
            if showButton {
                VStack{
                    Button(action: {
                        withAnimation {
                            showButton = false
                            isLoading = true
                        }
                        generateButtonPressed()
                        currPlay = Int.random(in: 1...5)
                    }) {
                        Text("Generate Music")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    ProgressView(value: Double(scoreModel.score) / 100.0)
                                    .progressViewStyle(MyProgressBarStyle(progressColor: .blue))
                                    .padding(.horizontal)
                }
            } else {
                if playcontrol{
                    VStack{
                        HStack {
                            Button(action: {
                                playcontrol.toggle()
                                if musicinit {
                                    audioPlayer.stopAudio()
                                    musicinit = false
                                }
                                addnotes = false
                                message = ""
                                wordCount = 0
                                withAnimation{
                                    showButton = true
                                }
                            }) {
                                Image(systemName: "autostartstop")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.yellow)
                            }.padding()
                            Button(action: {
                                if audioPlayer.isPlaying {
                                    audioPlayer.pauseAudio()
                                } else {
                                    audioPlayer.playAudio(currPlay: currPlay)
                                    musicinit = true
                                }
                            }) {
                                Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(audioPlayer.isPlaying ? .red : .green)
                            }.padding()
                            Button(action: {
                                // Code for adding notes
                                withAnimation{
                                    addnotes.toggle()
                                }
                            }) {
                                Image(systemName: "pencil.and.outline")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                            }.padding()
                        }
                        if addnotes{
                            VStack{
                                ZStack(alignment: .topLeading) {
                                    
                                    ZStack(alignment: .bottomTrailing) {
                                        TextEditor(text: $message)
                                            .font(.title2)
                                            .lineSpacing(20)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                            .padding()
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                                            .onChange(of: message) { _ in
                                                let words = message.split { $0 == " " || $0.isNewline }
                                                self.wordCount = words.count
                                            }
                                        Text("\(wordCount)")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                            .padding(.trailing)
                                            .padding()
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                            .shadow(radius: 3)
                                    )
                                    if message.isEmpty {
                                        Text("What's your feeling about this AI-created song?")
                                            .font(.title2)
                                            .foregroundColor(Color(UIColor.placeholderText))
                                            .padding()
                                    }
                                }
                                .padding()
                                RatingView()
                                Button(action: {
                                    withAnimation {
                                        scoreModel.score += 5
                                        addnotes.toggle()
                                    }
                                }) {
                                    Text("Submit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        ProgressView(value: Double(scoreModel.score) / 100.0 )
                                        .progressViewStyle(MyProgressBarStyle(progressColor: .blue))
                                        .padding(.horizontal)
                    }
                }
            }
            if isLoading {
                ProgressView("Music Generating...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .font(.title)
            }
            
        }.sheet(isPresented: $isScoreAchieved3) {
            ScoreAchievedView(isScoreAchieved: $isScoreAchieved3)
                .onReceive(ScoreModel.shared.$score) { score in
                    if score >= 90 {
                        isScoreAchieved3 = true
                    }
                }
        }

    }
    
    func generateButtonPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.3...0.4)) {
                withAnimation {
                    audioPlayer.isPlaying = false
                    addnotes = false
                    isLoading = false
                    playcontrol = true
                }
            }
    }
    
}
