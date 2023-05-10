import SwiftUI
import PencilKit

struct PaintView: View {
    @ObservedObject var scoreModel = ScoreModel.shared
    @State private var showPencilView = false
    @State private var canvasImage = UIImage(named: "1")!
    @State private var canvasSize: CGSize = .zero
    @State private var genfinish = false
    @State private var isLoading = false
    @State private var regenerate = false
    @State private var isScoreAchieved2 = false
    
    var body: some View{
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            VStack {
                if genfinish {
                    Text("Click ⬇️ to edit!").font(.largeTitle.bold())
                    Image(uiImage: canvasImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: canvasImage.size.width/3 * 2, height: canvasImage.size.height/3 * 2)
                        .onTapGesture {
                            self.showPencilView = true
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .shadow(color: Color.gray.opacity(0.5), radius: 20, x: 0, y: 0)
                }
                if !isLoading{
                    Button(action:{
                        if regenerate {
                            genfinish = false
                        }
                        withAnimation{
                            isLoading = !regenerate
                        }
                        canvasImage = UIImage(named: "1")!
                        if !regenerate{
                            generateButtonPressed()
                        }
                        regenerate.toggle()
                        }
                    ){
                        
                        Text(regenerate ? "Regenerate Picture" : "Generate Picture")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(regenerate ? Color.green : Color.blue)
                            .cornerRadius(20)
                    }
                    ProgressView(value: Double(scoreModel.score) / 100.0)
                        .progressViewStyle(MyProgressBarStyle(progressColor: .blue))
                        .padding(.horizontal)
                }
                
                if isLoading {
                    ProgressView("Painting Generating...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .font(.headline)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showPencilView) {
                PencilView(image: $canvasImage, showCanvas: $showPencilView){ n in
                    canvasImage = n
                }
            }
        }.sheet(isPresented: $isScoreAchieved2) {
            ScoreAchievedView(isScoreAchieved: $isScoreAchieved2)
                .onReceive(ScoreModel.shared.$score) { score in
                    if score >= 90 {
                        isScoreAchieved2 = true
                    }
                }
        }
    }
    
    func generateButtonPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.8...1.2)) {
                withAnimation {
                    isLoading = false 
                    genfinish = true
                }
            }
    }
}

struct PaintView_Previews: PreviewProvider {
    static var previews: some View {
        PaintView()
    }
}
