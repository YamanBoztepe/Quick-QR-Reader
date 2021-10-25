//
//  Extensions+String.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 20.10.2021.
//

import Foundation

extension String {
    func shortURL() -> String {
        if self.hasPrefix("www.") {
            return String(self.dropFirst(4))
        }
        return self
    }
}
