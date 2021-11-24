//
//  WebView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 19.10.2021.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var actions: WebActions
    @Binding var url: URL
    
    // MARK:- Required Methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        
        let wkWebView = WKWebView(frame: .zero, configuration: configuration)
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.uiDelegate = context.coordinator
        firstLoad(wkWebView: wkWebView)
        return wkWebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        load(wkWebView: uiView)
        shouldGoBack(wkWebView: uiView)
        shouldGoForward(wkWebView: uiView)
        shouldOpenSafari(WKWebView: uiView)
        shouldShare(WKWebView: uiView)
    }
    
    // MARK:- Actions
    private func firstLoad(wkWebView: WKWebView) {
        let request = URLRequest(url: url)
        loadWebView()
        wkWebView.load(request)
    }
    
    private func load(wkWebView: WKWebView) {
        if let loadedURL = wkWebView.url {
            let request = URLRequest(url: loadedURL)
            
            switch actions.shouldLoad {
            case .load:
                wkWebView.load(request)
            case .reload:
                wkWebView.reload()
            case .idle:
                return
            }
        }
    }
    
    private func shouldGoBack(wkWebView: WKWebView) {
        guard actions.backButtonTapped else { return }
        wkWebView.goBack()
    }
    
    private func shouldGoForward(wkWebView: WKWebView) {
        guard actions.forwardButtonTapped else { return }
        wkWebView.goForward()
    }
    
    private func shouldOpenSafari(WKWebView: WKWebView) {
        guard actions.safariButtonTapped, let url = WKWebView.url else { return }
        UIApplication.shared.open(url, options: [:]) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func shouldShare(WKWebView: WKWebView) {
        guard actions.shareButtonTapped, let url = WKWebView.url else { return }
        share(items: [url]) {
            actions.shareButtonTapped = false
        }
    }
    
    private func loadWebView() {
        if actions.shouldLoad == .idle {
            actions.shouldLoad = .load
        }
    }
    
    // MARK:- Coordinator Object
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var wkWebView: WebView
        
        init(_ wkWebView: WebView) {
            self.wkWebView = wkWebView
        }
        
        private func canRedirect(webView: WKWebView) {
            wkWebView.actions.canGoBack = webView.canGoBack
            wkWebView.actions.canGoForward = webView.canGoForward
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            wkWebView.loadWebView()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            canRedirect(webView: webView)
            wkWebView.actions.reset()
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load page: \(error.localizedDescription)")
            canRedirect(webView: webView)
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                wkWebView.loadWebView()
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
