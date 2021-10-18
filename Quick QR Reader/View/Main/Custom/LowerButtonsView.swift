//
//  LowerButtonsView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 10.10.2021.
//

import SwiftUI
import AVFoundation

struct LowerButtonsView: View {
    @State private var isFrontCameraActive = false
    
    var body: some View {
        HStack {
            Button(action: {
                Camera.shared.toggleTorch()
            }) {
                createImage(systemName: "bolt.circle", size: 60)
            }
            .disabled(isFrontCameraActive)
            
            Spacer()
            
            Button(action: {
                Camera.shared.flipCamera()
                isFrontCameraActive.toggle()
            }) {
                createImage(systemName: "arrow.triangle.2.circlepath.circle", size: 60)
            }
        }
    }
}

struct LowerButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        LowerButtonsView()
    }
}
