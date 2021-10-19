//
//  HistoryDataView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct HistoryDataView: View {
    @Binding var qrModel: QRModel
    let saveData: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    Text(qrModel.formattedDate)
                        .font(.subheadline.weight(.thin))
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
                Text(qrModel.content)
                    .font(.headline.weight(.light))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                qrModel.isFavorite.toggle()
                saveData()
            }) {
                createImage(systemName: qrModel.isFavorite ? "star.fill" : "star", size: 24)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .frame(height: 80)
    }
}

struct HistoryDataView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDataView(qrModel: .constant(QRModel(content: "www.google.com", createdDate: Date())), saveData: {})
            .previewLayout(.sizeThatFits)
    }
}
