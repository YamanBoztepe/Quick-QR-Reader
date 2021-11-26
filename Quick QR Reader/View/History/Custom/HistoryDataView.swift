//
//  HistoryDataView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct HistoryDataView: View {
    @Binding var qrModel: QRModel
    @Binding var presentableData: ScanResult
    let isEditing: Bool
    let saveData: (QRModel) -> Void
    
    var body: some View {
        if qrModel.content != HistoryViewModel.dummyDataID {
            HStack {
                Button(action: { bodyTapped() }) { informationBody }
                Spacer()
                if isEditing {
                    deleteButton
                } else {
                    favoriteButton
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .frame(height: 80)
        }
    }
    
    var informationBody: some View {
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
    }
    
    var favoriteButton: some View {
        Button(action: {
            qrModel.isFavorite.toggle()
            saveData(qrModel)
        }) {
            createImage(systemName: qrModel.isFavorite ? "star.fill" : "star", size: 24)
        }
    }
    
    var deleteButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                saveData(qrModel)
            }
        }) {
            Image(systemName: "trash")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.red)
        }
    }
    
    private func bodyTapped() {
        Ads.shared.present{}
        presentableData = ScanResult(shouldPresent: true, content: qrModel.content)
    }
}

struct HistoryDataView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDataView(qrModel: .constant(QRModel(content: "www.google.com", createdDate: Date())), presentableData: .constant(ScanResult(shouldPresent: false, content: "")), isEditing: true, saveData: {_ in })
            .previewLayout(.sizeThatFits)
    }
}
