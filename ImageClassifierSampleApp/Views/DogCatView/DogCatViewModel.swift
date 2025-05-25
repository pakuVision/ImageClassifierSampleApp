//
//  DogCatViewModel.swift
//  ImageClassifierSampleApp
//
//  Created by boardguy.vision on 2025/05/25.
//

import SwiftUI
import CoreML
import Vision

class DogCatViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var resultLabel: String = ""
    @Published var showPicker = false
    
    func selectImageButtonTapped() {
        showPicker = true
    }
    
    // 判別を行う
    func classifyButtonTapped() {
        guard let image, let ciImage = CIImage(image: image) else {
            resultLabel = "画像変換エラー\n別の画像を選択してください"
            return
        }
        
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all //  .cpuOnly, .cpuAndGPU, all (Neural Engine含む全て)
            
            let classifier = try DogCatImageClassifier(configuration: config)
            let model = try VNCoreMLModel(for: classifier.model)
            
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                Task { @MainActor in
                    withAnimation {
                        if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                            self?.resultLabel = "結果: \(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                        } else {
                            self?.resultLabel = "分類失敗"
                        }
                    }
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            try handler.perform([request])
        } catch {
            Task { @MainActor in
                self.resultLabel = "モデルエラー: \(error.localizedDescription)"
            }
        }
        
    }
}

