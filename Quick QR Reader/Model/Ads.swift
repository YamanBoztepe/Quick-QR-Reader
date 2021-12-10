//
//  Ads.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 26.11.2021.
//

import Foundation
import GoogleMobileAds

class Ads: NSObject, GADFullScreenContentDelegate {
    static let shared = Ads()
    
    private var interstitial: GADInterstitialAd?
    private var adWillDismess: (() -> Void)?
    private var didFail = false
    
    func load() {
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-6297661538267039/6546148975",
                               request: GADRequest() )
        { ad, error in
            if let error = error {
                print("Ads Error: \(error.localizedDescription)")
                self.didFail = true
                return
            }
            
            if let ad = ad {
                self.interstitial = ad
                self.didFail = false
                ad.fullScreenContentDelegate = self
            }
        }
    }
    
    func present(_ completionHandler: @escaping () -> Void) {
        adWillDismess = { completionHandler() }
        
        if let interstitialAd = interstitial,
           let root = UIApplication.shared.windows.first?.rootViewController
        {
            interstitialAd.present(fromRootViewController: root)
        } else {
            adWillDismess?()
            return
        }
        
        if didFail {
            adWillDismess?()
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content: \(error.localizedDescription)")
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will dismiss full screen content.")
        adWillDismess?()
    }
}
