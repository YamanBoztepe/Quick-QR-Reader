//
//  HistoryDataView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct HistoryDataView: View {
    let qrModel: QRModel
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Text(qrModel.content)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            VStack {
                Text(qrModel.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                
            }) {
                createImage(systemName: qrModel.isFavorite ? "star.fill" : "star", size: 24)
            }
        }
        .padding()
        .background(Color.white)
        .frame(height: 80)
    }
}

struct HistoryDataView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDataView(qrModel: QRModel(content: "www.google.com", createdDate: Date()))
            .previewLayout(.sizeThatFits)
    }
}
