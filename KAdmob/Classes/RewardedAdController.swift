import UIKit
import GoogleMobileAds

@objc public class RewardedAdController: UIViewController {
    private var rewardedAd: GADRewardedAd?
    private let adUnitID: String
    private var isAdLoaded = false // Track if ad is loaded

    @objc public init(adUnitID: String?) {
        guard let adUnitID = adUnitID, !adUnitID.isEmpty else {
            fatalError("Ad unit ID cannot be nil or empty.")
        }

        self.adUnitID = adUnitID
        super.init(nibName: nil, bundle: nil)
        loadRewardedAd()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use the custom initializer instead.")
    }

    @objc public func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                self?.isAdLoaded = false
                return
            }
            self?.rewardedAd = ad
            self?.isAdLoaded = true
            print("Rewarded ad loaded successfully.")
        }
    }

    @objc public func showAd(rewardHandler: @escaping (KRewardAdItem?) -> Void) {
        guard let rewardedAd = rewardedAd, isAdLoaded else {
            print("Rewarded ad is not ready yet.")
            loadRewardedAd() // Optionally reload the ad
            return
        }
       
        rewardedAd.present(fromRootViewController: self) {
            let reward = KRewardAdItem(rewardedAd.adReward.type, Int(truncating: rewardedAd.adReward.amount))
            rewardHandler(reward)
        }
        
        // Mark the ad as not loaded after showing and reload a new one
        isAdLoaded = false
        loadRewardedAd()
    }
}
