//
//  WebView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 19.10.2021.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
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
    private func load(wkWebView: WKWebView) {
        guard actions.shouldLoad else { return }
        let request = URLRequest(url: wkWebView.url ?? url)
        
        if let loadedURL = wkWebView.url {
            if loadedURL == url {
                wkWebView.reload()
            } else {
                wkWebView.load(request)
            }
            
        } else {
            wkWebView.load(request)
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
        UIApplication.shared.open(url, options: [:])
    }
    
    private func shouldShare(WKWebView: WKWebView) {
        // TODO: Will be implemented
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
            if !wkWebView.actions.shouldLoad {
                wkWebView.actions.shouldLoad = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            canRedirect(webView: webView)
            wkWebView.actions.reset()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load page: \(error.localizedDescription)")
            canRedirect(webView: webView)
            wkWebView.actions.reset()
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                wkWebView.actions.shouldLoad = true
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
