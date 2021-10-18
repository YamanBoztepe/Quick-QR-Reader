//
//  QRModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import Foundation

struct QRModel: Codable {
    let content: String
    var isFavorite: Bool = false
    
    private let createdDate: Date
    var formattedDate: String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformat.dateStyle = .short
        return dateformat.string(from: createdDate)
    }
    
    init(content: String, createdDate: Date) {
        self.content = content
        self.createdDate = createdDate
    }
}
