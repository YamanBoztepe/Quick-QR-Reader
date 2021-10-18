//
//  WindowView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 10.10.2021.
//

import SwiftUI

struct WindowView: View {
    @Binding var windowSettings: WindowSettings
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width
            let adjustment: CGFloat = size * windowSettings.scale
            
            Path { path in
                
                path.move(to: CGPoint(x: 0, y: size/2 - adjustment))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: size/2 - adjustment, y: 0))
                
                path.move(to: CGPoint(x: size/2 + adjustment, y: 0))
                path.addLine(to: CGPoint(x: size, y: 0))
                path.addLine(to: CGPoint(x: size, y: size/2 - adjustment))
                
                path.move(to: CGPoint(x: size, y: size/2 + adjustment))
                path.addLine(to: CGPoint(x: size, y: size))
                path.addLine(to: CGPoint(x: size/2 + adjustment, y: size))
                
                path.move(to: CGPoint(x: size/2 - adjustment, y: size))
                path.addLine(to: CGPoint(x: 0, y: size))
                path.addLine(to: CGPoint(x: 0, y: size/2 + adjustment))
            }
            .stroke(Color.black, style: StrokeStyle(lineWidth: windowSettings.lineWidth, lineCap: .round))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct WindowView_Previews: PreviewProvider {
    static var previews: some View {
        WindowView(windowSettings: .constant(WindowSettings(scale: 0.1, lineWidth: 10)))
    }
}
