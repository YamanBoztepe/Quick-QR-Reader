//
//  WindowSettingsView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct WindowSettingsView: View {
    @Binding var windowSettings: WindowSettings
    @State private var isHidden = true
    
    var body: some View {
        if isHidden {
            SectionHeader(isHidden: $isHidden, text: "Settings", color: .white)
        } else {
            scrollableContent
        }
    }
    
    var scrollableContent: some View {
        ScrollView(.vertical) {
            SectionHeader(isHidden: $isHidden, text: "Settings", color: .white)
            settings
        }
        .aspectRatio(3, contentMode: .fit)
    }
    
    var settings: some View {
        VStack {
            Text("Line Length")
                .foregroundColor(.black)
            Slider(value: $windowSettings.scale, in: 0.1...0.4) { isEditing in
                if !isEditing {
                    StoreData.save(data: windowSettings, key: .windowSettings)
                }
            }
            .accentColor(.blue)
            
            Text("Line Width")
                .foregroundColor(.black)
            Slider(value: $windowSettings.lineWidth, in: 1...20) { isEditing in
                if !isEditing {
                    StoreData.save(data: windowSettings, key: .windowSettings)
                }
            }
            .accentColor(.blue)
        }
    }
}

struct WindowSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WindowSettingsView(windowSettings: .constant(WindowSettings(scale: 0.2, lineWidth: 10)))
    }
}
