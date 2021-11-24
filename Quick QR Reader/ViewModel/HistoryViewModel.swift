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
    @Published var isEditing = false
    @Published var presentableData = ScanResult(shouldPresent: false, content: "")
    
    static let dummyDataID = "_QuickQrReaderDummyData_"
    var timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    var isDummyData: Bool {
        data.contains(where: { $0.content == Self.dummyDataID } )
    }
    
    // MARK:- Get, Save and Delete Data in Documents
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
    
    func saveData(_ model: QRModel) {
        if isEditing {
            if data.count == 1 {
                let dummyModel = QRModel(content: Self.dummyDataID, createdDate: Date())
                data.append(dummyModel)
            }
            
            guard let index = data.firstIndex(of: model) else { return }
            data.remove(at: index)
        }
        
        Documents.shared.save(data, in: .qrDataPath)
    }
    
    func deleteDummyData() {
        if isDummyData {
            if let index = data.firstIndex(where: { $0.content == Self.dummyDataID } ) {
                data.remove(at: index)
                Documents.shared.save(data, in: .qrDataPath)
            }
        }
    }
    
    // MARK:- Wink Effect
    func timer(shouldStop: Bool) {
        if shouldStop {
            timer.upstream.connect().cancel()
        } else {
            timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
        }
    }
    
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
