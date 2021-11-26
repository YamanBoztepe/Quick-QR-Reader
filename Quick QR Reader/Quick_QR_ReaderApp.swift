//
//  Quick_QR_ReaderApp.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 9.10.2021.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

@main
struct Quick_QR_ReaderApp: App {
    
    init() {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            
        } else {
            ATTrackingManager.requestTrackingAuthorization { status in
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .navigationBarHidden(true)
            }
        }
    }
}
