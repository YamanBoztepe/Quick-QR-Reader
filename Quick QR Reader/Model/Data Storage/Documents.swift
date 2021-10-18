//
//  Documents.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import Foundation

class Documents {
    // Path names for accessing document
    enum Path: String {
        case qrDataPath = "qr.data"
    }
    
    // MARK:- Save and Load Data in Documents
    typealias DocumentResults<U> = (Result<U,Error>) -> Void where U: Decodable
    
    func load<T: Decodable>(from path: Path, as: T.Type, completion: @escaping DocumentResults<T>) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let data = try Data(contentsOf: self.getFileURL(for: path))
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(jsonData))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func save<T: Encodable>(_ data: T, in path: Path) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let jsonData = try JSONEncoder().encode(data)
                try jsonData.write(to: self.getFileURL(for: path))
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- Helper Methods
    private func getFileURL(for path: Path) -> URL {
        do {
            let documents = try FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false)
            
            return documents.appendingPathComponent(path.rawValue)
            
        } catch {
            fatalError("Can't find documents directory")
        }
    }
}
