//
//  ContentView.swift
//  ImageClassifierSampleApp
//
//  Created by boardguy.vision on 2025/05/25.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            DogCatView()
                .tabItem {
                    Image(systemName: "dog.circle.fill")
                    Text("DogCat")
                }
                .tag(1)
        }
        
    }
}

#Preview {
    ContentView()
}
