//
//  WebViewModel.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 20.10.2021.
//

import Foundation
import WebKit

class WebViewModel: ObservableObject {
    @Published var wkWebView = WKWebView()
    @Published var actions = WebActions()
}
