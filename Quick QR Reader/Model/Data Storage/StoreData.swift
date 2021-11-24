//
//  StoreData.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import Foundation

class StoreData {
    // Keys for accesing data on UserDefaults
    enum StoreDataKeys: String {
        case windowSettings = "WindowSettings"
        case generatorText = "GeneratorText"
    }
    
    // MARK:- Save, Fetch, Replace and Delete data on UserDefaults
    static func save<T: Encodable>(data: T, key: StoreDataKeys) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let jsonString = String(data: jsonData, encoding: .utf8)
            UserDefaults.standard.setValue(jsonString, forKey: key.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getData<T: Decodable>(as: T.Type, key: StoreDataKeys) -> T? {
        if let jsonObject = UserDefaults.standard.value(forKey: key.rawValue),
           let jsonString = jsonObject as? String,
           let jsonData = jsonString.data(using: .utf8)
        {
            do {
                let data = try JSONDecoder().decode(T.self, from: jsonData)
                return data
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func replace<T: Encodable>(data: T, key: StoreDataKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        save(data: data, key: key)
    }
    
    static func deleteData(key: StoreDataKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
