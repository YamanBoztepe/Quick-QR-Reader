//
//  Web.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 19.10.2021.
//

import SwiftUI

struct Web: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var viewModel = WebViewModel()
    
    @State var url: URL
    var shortURL: String {
        url.host?.shortURL() ?? url.absoluteString
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                WebBar(reload: $viewModel.actions.shouldLoad, url: shortURL)
                    .frame(height: geometry.size.height/35)
                    .padding(.top, geometry.safeAreaInsets.top + 16)
                WebView(actions: $viewModel.actions, url: $url)
                WebBottomBar(actions: $viewModel.actions)
                    .frame(height: geometry.size.height/35)
                    .font(.system(size: geometry.size.height/35))
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
            }
            .onChange(of: scenePhase) { value in
                
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
    
}

struct Web_Previews: PreviewProvider {
    static var previews: some View {
        Web(url: URL(string: "https://www.google.com")!)
    }
}
