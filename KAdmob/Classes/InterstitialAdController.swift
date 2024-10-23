import UIKit
import GoogleMobileAds

@objc public class InterstitialAdController: UIViewController {
    private var interstitial: GADInterstitialAd?
    private let adUnitID: String
    private var isAdLoaded = false // Track if ad is loaded

    @objc public init(adUnitID: String?) {
        guard let adUnitID = adUnitID, !adUnitID.isEmpty else {
            fatalError("Ad unit ID cannot be nil or empty.")
        }

        self.adUnitID = adUnitID
        super.init(nibName: nil, bundle: nil)
        loadInterstitialAd()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use the custom initializer instead.")
    }

    @objc public func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                self?.isAdLoaded = false // Mark ad as not loaded
                return
            }
            self?.interstitial = ad
            self?.isAdLoaded = true // Ad is loaded successfully
            print("Interstitial ad loaded successfully.")
        }
    }

    @objc public func showInterstitial(from viewController: UIViewController, loadNewAd: Bool) {
        guard let interstitial = interstitial, isAdLoaded else {
            print("Interstitial ad is not ready yet.")
            if(loadNewAd){
                loadInterstitialAd()
            }
            return
        }

        interstitial.present(fromRootViewController: viewController)
        print("Showing interstitial ad.")
        
        // Mark the ad as not loaded after showing and reload a new one
        isAdLoaded = false
        if(loadNewAd){
            loadInterstitialAd()
        }
    }
}
