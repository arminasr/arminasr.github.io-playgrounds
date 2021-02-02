import SoundAnalysis

class SoundClassifierObserver: NSObject {
    func analyzeSoundSample(at url: URL) {
        // 1. Initialize Sound Analyzer, model and request
        guard let fileAnalyzer = try? SNAudioFileAnalyzer(url: url),
              let model = try? CatsVsDogs(configuration: MLModelConfiguration()).model,
              let request = try? SNClassifySoundRequest(mlModel: model) else { return }
        
        // 2. Add request and analyze the sound sample
        try? fileAnalyzer.add(request, withObserver: self)
        fileAnalyzer.analyze()
    }
}

extension SoundClassifierObserver: SNResultsObserving {
    func requestDidComplete(_ request: SNRequest) {
        print("Request: \(request.description) completed.")
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Request: \(request.description) failed with error \(error.localizedDescription).")
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        result.classifications
            .filter { $0.confidence > 0.85 }
            .forEach {
                print("Class: \($0.identifier) Confidence: \($0.confidence * 100)%")
            }
    }
}


if let testAudioURL = Bundle.main.url(forResource: "cat_152", withExtension: "wav") {
    let observer = SoundClassifierObserver()
    observer.analyzeSoundSample(at: testAudioURL)
}





