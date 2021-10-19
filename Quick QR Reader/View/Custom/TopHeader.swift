//
//  TopHeader.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 18.10.2021.
//

import SwiftUI

struct TopHeader: View {
    let previousScreen: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                action()
            }){
                Label(previousScreen, systemImage: "chevron.left")
                    .foregroundColor(color)
                    .font(.headline.weight(.bold))
                    .padding(.leading, 8)
            }
            
            Spacer()
        }
    }
}

struct TopHeader_Previews: PreviewProvider {
    static var previews: some View {
        TopHeader(previousScreen: "Main", color: .red, action: {})
            .previewLayout(.sizeThatFits)
    }
}
