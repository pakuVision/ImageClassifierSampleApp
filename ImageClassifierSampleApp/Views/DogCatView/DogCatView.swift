//
//  DogCatView.swift
//  ImageClassifierSampleApp
//
//  Created by boardguy.vision on 2025/05/25.
//

import SwiftUI


struct DogCatView: View {
    
    @StateObject var viewModel = DogCatViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.resultLabel)
                .bold()
                .font(.system(size: 20))
                .foregroundStyle(.blue)
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .background(RoundedRectangle(cornerRadius: 6))
                Button {
                    viewModel.showPicker = true
                } label: {
                    Text("写真を選び直す")
                }

            } else {
                button
            }
        
        }
        .overlay(alignment: .bottom, content: {
            classifyButton
                .offset(y: 200)
            
        })
        .sheet(isPresented: $viewModel.showPicker) {
            PhotoPicker(image: $viewModel.image)
        }
        
    }
    
    private var button: some View {
        Button {
            viewModel.selectImageButtonTapped()
        } label: {
            VStack {
                Image(systemName: "photo")
                    .font(.system(size: 80))
                Text("犬か猫の写真を選択")
                    .font(.callout)
            }
            .foregroundStyle(.gray)
        }
    }
    
    private var classifyButton: some View {
        Button {
            viewModel.classifyButtonTapped()
        } label: {
            HStack {
                Image(systemName: "bonjour")
                Text("判別する")
                    .bold()
            }
            .foregroundStyle(.white)
            .frame(width: 200, height: 50)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(viewModel.image  == nil ? .gray.opacity(0.5) : .blue)
            }
        }
        .disabled(viewModel.image == nil)
    }
}

#Preview {
    DogCatView()
}

