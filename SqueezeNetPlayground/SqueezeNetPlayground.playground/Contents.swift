import CoreML
import UIKit

func getPredictions(for image: UIImage) {
    let errorMessage = "Could not predict with a given picture"
    // 1. Initialize the SqueezeNet model
    guard let model = try? SqueezeNet(configuration: MLModelConfiguration()),
          // 2. Resize image & convert to CVPixelBuffer to meet the input requirements
          let resizedImage = image.resize(to: CGSize(width: 227, height: 227)),
          let buffer = resizedImage.toCVPixelBuffer(),
          // 3. Get predictions 🚀
          let predictions = try? model.prediction(image: buffer).classLabelProbs else {
        print(errorMessage)
        return
    }

    let sortedPredictions = predictions.sorted { $0.value > $1.value }
    sortedPredictions.forEach {
        print("\(String(format: "%.1f", $0.value * 100))% probability: \($0.key)")
    }
}

if let image = UIImage(named: "myCatPic.jpg") {
    getPredictions(for: image)
}
