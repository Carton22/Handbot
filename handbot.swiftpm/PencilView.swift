import SwiftUI
import PencilKit
import UIKit
import Foundation

struct PencilView: View {
    @ObservedObject var scoreModel = ScoreModel.shared
    @Binding var image: UIImage
    
    @Binding var showCanvas: Bool
    
    let onSave: (UIImage) -> Void
    
    @State private var drawingOnImage: UIImage = UIImage()
    @State private var canvasView: PKCanvasView = PKCanvasView()
    
    var body: some View {
        ZStack{
            Color.lightBackground.ignoresSafeArea()
            VStack {
                Button {
                    save()
                    scoreModel.score += 5
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(CanvasView(canvasView: $canvasView, onSaved: onChanged), alignment: .bottomLeading)
            }
        }
    }
    
    private func onChanged() -> Void {
        self.drawingOnImage = canvasView.drawing.image(
            from: canvasView.bounds, scale: UIScreen.main.scale)
    }
    
    private func initCanvas() -> Void {
        self.canvasView = PKCanvasView()
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.becomeFirstResponder()
    }
    
    private func save() -> Void {
        onSave(self.image.mergeWith(topImage: drawingOnImage))
        showCanvas = false
    }
}

public extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        
        UIGraphicsBeginImageContext(size)
        
        
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
