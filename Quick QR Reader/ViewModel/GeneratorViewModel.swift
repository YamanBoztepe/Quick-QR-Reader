//
//  GeneratorViewModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 21.11.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

class GeneratorViewModel {
    var isCodeGenerated = false
    
    func generateQRCode(from string: String, completion: @escaping ((UIImage?) -> Void)) {
        let data = Data(string.utf8)
        let filter = CIFilter.qrCodeGenerator()
        let transform = CGAffineTransform(scaleX: 100, y: 100)
        
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let cgimg = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                let image = UIImage(cgImage: cgimg)
                completion(image)
            }
        }
    }
    
    func save(text: String) {
        let data = isCodeGenerated ? "" : text
        StoreData.replace(data: data, key: .generatorText)
    }
}
