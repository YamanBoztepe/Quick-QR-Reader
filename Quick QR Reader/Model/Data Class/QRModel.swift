//
//  QRModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import Foundation

struct QRModel: Codable, Identifiable, Equatable {
    var id = UUID()
    let content: String
    var isFavorite: Bool = false
    
    let createdDate: Date
    var formattedDate: String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformat.dateStyle = .long
        return dateformat.string(from: createdDate)
    }
    
    init(content: String, createdDate: Date) {
        self.content = content
        self.createdDate = createdDate
    }
    
    static func ==(lhs: QRModel, rhs: QRModel) -> Bool {
        return lhs.content == rhs.content && lhs.isFavorite == rhs.isFavorite && lhs.createdDate == rhs.createdDate
    }
}
