//
//  Documents.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import Foundation

class Documents {
    static let shared = Documents()
    
    private init() { }
    
    // Path names for accessing document
    enum Path: String {
        case qrDataPath = "qr.data"
    }
    
    // MARK:- Save, Load, Delete Data in Documents
    typealias DocumentResults<U> = (Result<U,Error>) -> Void where U: Decodable
    
    func load<T: Decodable>(from path: Path, as: T.Type, completion: @escaping DocumentResults<T>) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self, self.fileExists else { return }
            
            do {
                let data = try Data(contentsOf: self.getFileURL(for: path))
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(jsonData))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func append<T: Codable>(_ data: T, in path: Path) {
        DispatchQueue.global(qos: .background).async {
            if self.fileExists {
                self.load(from: path, as: [T].self) { result in
                    switch result {
                    case.success(let loadedData):
                        var newData = loadedData
                        newData.append(data)
                        self.save(newData, in: path)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
                self.save([data], in: path)
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
    
    func delete(path: Path) {
        DispatchQueue.global(qos: .background).async {
            if self.fileExists {
                do {
                    try FileManager.default.removeItem(atPath: path.rawValue)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK:- Helpers
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
    
    private var fileExists: Bool {
        let filePath = self.getFileURL(for: .qrDataPath).path
        return FileManager.default.fileExists(atPath: filePath)
    }
}
