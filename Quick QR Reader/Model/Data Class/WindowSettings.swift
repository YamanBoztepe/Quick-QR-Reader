//
//  WindowSettings.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 10.10.2021.
//

import SwiftUI

struct WindowSettings: Codable {
    var scale: CGFloat
    var lineWidth: CGFloat
    
    static func getSettings() -> WindowSettings {
        if let result = StoreData.getData(as: WindowSettings.self, key: .windowSettings) {
            return result
        } else {
            return WindowSettings(scale: 0.3, lineWidth: 10)
        }
    }
    
    func saveSettings() {
        StoreData.save(data: self, key: .windowSettings)
    }
}
