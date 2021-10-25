//
//  Loading.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 24.10.2021.
//

import SwiftUI

struct Loading: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        if isPresented {
            ZStack {
                content
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        } else {
            content
        }
    }
}
