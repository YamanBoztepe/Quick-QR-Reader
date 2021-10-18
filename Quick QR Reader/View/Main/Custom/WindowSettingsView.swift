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
        if isHidden { settingsHeader } else { scrollableContent }
    }
    
    var scrollableContent: some View {
        ScrollView(.vertical) {
            settingsHeader
            settings
        }
        .aspectRatio(3, contentMode: .fit)
    }
    
    var settingsHeader: some View {
        Button(action: {
            isHidden.toggle()
        }) {
            HStack {
                Text("Settings")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline.weight(.semibold))
                    .padding([.leading, .bottom], 8)
                Spacer()
                Image(systemName: isHidden ? "arrow.right" : "arrow.down")
                Spacer()
            }
            .foregroundColor(.black)
        }
    }
    
    var settings: some View {
        VStack {
            Text("Line Length")
                .foregroundColor(.black)
            Slider(value: $windowSettings.scale, in: 0.1...0.4) { isEditing in
                if !isEditing {
                    windowSettings.saveSettings()
                }
            }
            .accentColor(.blue)
            
            Text("Line Width")
                .foregroundColor(.black)
            Slider(value: $windowSettings.lineWidth, in: 1...20) { isEditing in
                if !isEditing {
                    windowSettings.saveSettings()
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
