//
//  SectionHeader.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 18.10.2021.
//

import SwiftUI

struct SectionHeader: View {
    @Binding var value: Bool
    var text: String
    var color: Color
    
    var body: some View {
        Button(action: {
            value.toggle()
        }) {
            HStack {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline.weight(.semibold))
                    .padding([.leading, .bottom], 8)
                Spacer()
                Image(systemName: value ? "arrow.right" : "arrow.down")
                Spacer()
            }
            .foregroundColor(color)
        }
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(value: .constant(false), text: "Tap", color: .black)
            .previewLayout(.sizeThatFits)
    }
}
