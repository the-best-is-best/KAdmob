import UIKit
import GoogleMobileAds

@objc public class InterstitialAdView: UIView, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    private let adUnitID: String

    // Custom initializer to accept the ad unit ID
    init(frame: CGRect, adUnitID: String?) {
        // Ensure adUnitID is not nil or empty, otherwise throw an exception
        guard let adUnitID = adUnitID, !adUnitID.isEmpty else {
            fatalError("Ad unit ID cannot be nil or empty.")
        }
        
        self.adUnitID = adUnitID
        super.init(frame: frame)
        loadInterstitialAd()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use the custom initializer instead.")
    }

    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [self] (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
    }

    func showInterstitial(from viewController: UIViewController) {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: viewController)
        } else {
            print("Interstitial ad is not ready yet.")
        }
    }

  
}

