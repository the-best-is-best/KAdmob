import UIKit
import GoogleMobileAds

@objc public class RewardedInterstitialAdController: UIViewController {
    
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    private let adUnitID: String

    // Custom initializer to accept the ad unit ID
    @objc public init(adUnitID: String?) {
        // Ensure adUnitID is not nil or empty, otherwise throw an exception
        guard let adUnitID = adUnitID, !adUnitID.isEmpty else {
            fatalError("Ad unit ID cannot be nil or empty.")
        }
        
        self.adUnitID = adUnitID
        super.init(nibName: nil, bundle: nil)
        
        loadRewardedInterstitialAd() // Load ad initially
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use the custom initializer instead.")
    }

    // Load a rewarded interstitial ad
    @objc public func loadRewardedInterstitialAd() {
        // Async ad loading
        Task {
            do {
                rewardedInterstitialAd = try await GADRewardedInterstitialAd.load(
                    withAdUnitID: adUnitID,
                    request: GADRequest()
                )
                print("Rewarded interstitial ad loaded successfully.")
            } catch {
                print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
        }
    }

    // Show the ad
    @objc public func showAd(rewardHandler: @escaping (KRewardAdItem?) -> Void) {
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            print("Rewarded interstitial ad is not ready yet.")
            return
        }
        
        // Ensure the view is loaded and visible
        guard self.isViewLoaded, self.view.window != nil else {
            print("ViewController is not in a visible state.")
            return
        }

        rewardedInterstitialAd.present(fromRootViewController: self) {
            let reward = KRewardAdItem()
            reward.type = rewardedInterstitialAd.adReward.type
            reward.ammount = Int(truncating: rewardedInterstitialAd.adReward.amount)
            // Call the rewardHandler with the reward item
            rewardHandler(reward)

            // Load a new ad after the current ad is presented and the reward has been handled
            self.loadRewardedInterstitialAd()
        }
    }
}
