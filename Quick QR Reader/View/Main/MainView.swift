//
//  MainView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            ScannerView { result in
                switch result {
                case .success(let data):
                    print("MainView: \(data)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            ScanContentView(windowSettings: $viewModel.windowSettings)
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
