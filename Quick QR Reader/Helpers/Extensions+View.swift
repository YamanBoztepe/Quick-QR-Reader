//
//  Extensions+View.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

extension View {
    func createImage(systemName: String, size: CGFloat) -> some View {
        Image(systemName: systemName)
            .renderingMode(.original)
            .resizable()
            .frame(width: size, height: size)
    }
}
