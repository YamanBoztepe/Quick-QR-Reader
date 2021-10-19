//
//  HistoryViewModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 18.10.2021.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var data = [QRModel]()
    @Published var isHistoryHidden: Bool = true
    @Published var isFavHidden: Bool = true
    @Published var dynamicOpacity: Double = 1
    @Published var repeatAgain = false
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    // MARK:- Get and Save Data in Documents
    func getData() {
        Documents.shared.load(from: .qrDataPath, as: [QRModel].self) { result in
            switch result {
            case .success(let qrData):
                DispatchQueue.main.async {
                    self.data = qrData.sorted(by: { $0.createdDate > $1.createdDate })
                }
                print("HistoryViewModel: \(qrData)")
            case .failure(let error):
                print("HistoryViewModel: \(error.localizedDescription)")
            }
        }
    }
    
    func saveData() {
        Documents.shared.save(data, in: .qrDataPath)
    }
    
    // MARK:- Wink Effect
    func winkEffect() {
        if !repeatAgain {
            dynamicOpacity -= 0.01
            repeatAgain = dynamicOpacity <= 0
        } else {
            dynamicOpacity += 0.01
            repeatAgain = !(dynamicOpacity >= 0.8)
        }
    }
}
