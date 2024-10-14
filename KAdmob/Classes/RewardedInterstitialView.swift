import UIKit
import GoogleMobileAds

class RewardedInterstitialAdView: UIView {
    
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    private let adUnitID: String

    // Custom initializer to accept the ad unit ID
    init(frame: CGRect, adUnitID: String?) {
        // Ensure adUnitID is not nil or empty, otherwise throw an exception
        guard let adUnitID = adUnitID, !adUnitID.isEmpty else {
            fatalError("Ad unit ID cannot be nil or empty.")
        }
        
        self.adUnitID = adUnitID
        super.init(frame: frame)
        
        loadRewardedInterstitialAd()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use the custom initializer instead.")
    }

    private func loadRewardedInterstitialAd() {
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

    func showAd(from viewController: UIViewController, rewardHandler: @escaping (GADAdReward?) -> Void) {
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            print("Rewarded interstitial ad is not ready yet.")
            return
        }
        
        rewardedInterstitialAd.present(fromRootViewController: viewController) {
            // Call the rewardHandler with the reward item
            rewardHandler(rewardedInterstitialAd.adReward)
        }
    }
}
