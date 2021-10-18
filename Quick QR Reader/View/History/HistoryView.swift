//
//  HistoryView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        List {
            Section(header: Text("History")) {
                ForEach(1...10, id: \.self) { _ in
                    HistoryDataView(qrModel: QRModel(content: "www.google.com", createdDate: Date()))
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
        .onAppear { setAppearances() }
        .listStyle(SidebarListStyle())
    }
    
    private func setAppearances() {
        UITableView.appearance().tintColor = .black
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
