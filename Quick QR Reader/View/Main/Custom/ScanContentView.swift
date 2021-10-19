//
//  ScanContentView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct ScanContentView: View {
    @Binding var windowSettings: WindowSettings
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white.opacity(0.2))
            
            VStack {
                scanArea
                WindowSettingsView(windowSettings: $windowSettings)
            }
        }
        .compositingGroup()
    }
    
    var scanArea: some View {
        ZStack {
            scanContent
                .padding()
            
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .blendMode(.destinationOut)
                .padding()
        }
    }
    
    var scanContent: some View {
        VStack(spacing: 15) {
            UpperButtonsView()
            WindowView(windowSettings: $windowSettings)
            LowerButtonsView()
        }
    }
}

struct ScanContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScanContentView(windowSettings: .constant(WindowSettings(scale: 0.2, lineWidth: 10)))
    }
}
