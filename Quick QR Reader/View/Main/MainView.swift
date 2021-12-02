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
            ScannerView(startScanning: $viewModel.startScanning, completion: viewModel.handleScan(result:))
            ScanContentView(windowSettings: $viewModel.windowSettings)
        }
        .ignoresSafeArea()
        .onAppear { Ads.shared.load() }
        .fullScreenCover(isPresented: $viewModel.metadataOutput.shouldPresent,
                         onDismiss: { viewModel.startScanning = true },
                         content: { presentOutput(viewModel.metadataOutput.content) })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
