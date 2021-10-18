//
//  MainViewModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 10.10.2021.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var windowSettings: WindowSettings = .getSettings()
    
    func handleScan(result: Result<QRModel, CaptureError>) {
        switch result {
        case .success(let result):
            print(result.formattedDate)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
