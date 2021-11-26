//
//  InterstitialAdsView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 26.11.2021.
//

import SwiftUI
import GoogleMobileAds

struct InterstitialAdsView: UIViewControllerRepresentable {
    @Binding var shouldPresent: Bool
    private var interstitial: GADInterstitialAd?
    
    init(shouldPresent: Binding<Bool>) {
        self._shouldPresent = shouldPresent
    }
    
    func makeUIViewController(context: Context) -> InterstitialAdsViewController {
        let vc = InterstitialAdsViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func makeCoordinator() -> InterstitialAdsCoordinator {
        InterstitialAdsCoordinator(parent: self)
    }
    
    func updateUIViewController(_ uiViewController: InterstitialAdsViewController, context: Context) {
        
    }
    
    class InterstitialAdsViewController: UIViewController {
        var delegate: InterstitialAdsCoordinator?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadAd()
        }
        
        private func loadAd() {
            GADInterstitialAd.load(
                withAdUnitID: "ca-app-pub-3940256099942544/1458002511",
                request: GADRequest()) { ad, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let ad = ad {
                    self.delegate?.set(interstitial: ad)
                    if self.delegate?.canShowAd == true {
                        ad.present(fromRootViewController: self)
                    }
                }
            }
        }
    }
    
    class InterstitialAdsCoordinator: NSObject, GADFullScreenContentDelegate {
        var parent: InterstitialAdsView
        var canShowAd: Bool {
            parent.shouldPresent
        }
        
        init(parent: InterstitialAdsView) {
            self.parent = parent
        }
        
        func set(interstitial: GADInterstitialAd) {
            parent.interstitial = interstitial
            parent.interstitial?.fullScreenContentDelegate = self
        }
        
        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            print("Ad did fail to present full screen content: \(error.localizedDescription)")
            parent.shouldPresent = false
        }
        
        func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("Ad did present full screen content.")
            parent.shouldPresent = false
        }
        
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("Ad did dismiss full screen content.")
        }
    }
}
