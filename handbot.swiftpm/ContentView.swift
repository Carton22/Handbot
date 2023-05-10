import SwiftUI
import PencilKit


struct ContentView: View {

    @State private var selectedTab = 1
    @State private var showintro = true
    var body: some View {
            TabView(selection: $selectedTab) {
                TextView()
                    .tabItem {
                        Label("Text", systemImage: "character.textbox")
                    }.tag(1)
                PaintView()
                    .tabItem {
                        Label("Paint", systemImage: "paintpalette")
                    }.tag(2)
                AudioView()
                    .tabItem {
                        Label("Listen", systemImage: "music.quarternote.3")
                    }.tag(3)
            }.accentColor(.blue)
            .sheet(isPresented: $showintro) {
                IntroView(showintro:$showintro)
            }
            .preferredColorScheme(.dark)
        
    }
}

