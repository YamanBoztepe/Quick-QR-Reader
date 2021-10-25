//
//  WebActions.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 22.10.2021.
//

import Foundation

struct WebActions {
    var shouldLoad = true
    var backButtonTapped = false
    var safariButtonTapped = false
    var forwardButtonTapped = false
    var shareButtonTapped = false
    
    var canGoBack = false
    var canGoForward = false
    
    mutating func reset() {
        shouldLoad = false
        backButtonTapped = false
        safariButtonTapped = false
        forwardButtonTapped = false
        shareButtonTapped = false
    }
}
