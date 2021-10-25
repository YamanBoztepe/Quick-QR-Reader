//
//  MainViewModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 10.10.2021.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var windowSettings = WindowSettings(scale: 0.3, lineWidth: 10)
    @Published var metadataOutput = ScanResult(shouldPresent: false, content: "")
    @Published var startScanning = true
    
    init() {
        getSettings()
    }
    
    private func getSettings() {
        if let result = StoreData.getData(as: WindowSettings.self, key: .windowSettings) {
            windowSettings = result
        }
    }
    
    func handleScan(result: Result<QRModel, CaptureError>) {
        switch result {
        case .success(let result):
            metadataOutput = ScanResult(shouldPresent: true,
                                        content: result.content)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
