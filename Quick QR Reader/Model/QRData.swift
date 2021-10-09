//
//  QRData.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import Foundation

class QRData: ObservableObject {
    @Published var qrModel: [QRModel] = []
    
    private static var fileURL: URL {
        do {
            let documents = try FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false)
            
            return documents.appendingPathComponent("qr.data")
            
        } catch {
            fatalError("Can't find documents directory")
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let jsonData = try JSONEncoder().encode(self.qrModel)
                try jsonData.write(to: Self.fileURL)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: Self.fileURL)
                let jsonData = try JSONDecoder().decode([QRModel].self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.qrModel = jsonData
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
