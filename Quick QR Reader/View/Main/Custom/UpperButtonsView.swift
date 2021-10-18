//
//  UpperButtonsView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 10.10.2021.
//

import SwiftUI

struct UpperButtonsView: View {
    
    var body: some View {
            HStack {
                Button(action: {
                    
                }) {
                    createImage(systemName: "plus.circle", size: 60)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    createImage(systemName: "line.horizontal.3.circle", size: 60)
                }
            }
    }
}

struct UpperButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        UpperButtonsView()
            .previewLayout(.sizeThatFits)
    }
}
