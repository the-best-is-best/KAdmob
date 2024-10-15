import UIKit
import GoogleMobileAds

@objc public class RewardedAdController: UIViewController {

    private var rewardedAd: GADRewardedAd?
    private let adUnitID: String

    // Custom initializer to accept the ad unit ID
    @objc public init(adUnitID: String?) {
        // Ensure adUnitID is not nil or empty, otherwise throw an exception
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

    private func loadRewardedAd() {
        Task {
            do {
                rewardedAd = try await GADRewardedAd.load(
                    withAdUnitID: adUnitID,
                    request: GADRequest()
                )
                print("Rewarded ad loaded successfully.")
            } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
            }
        }
    }

    @objc public func showAd(rewardHandler: @escaping (GADAdReward?) -> Void) {
        guard let rewardedAd = rewardedAd else {
            print("Rewarded ad is not ready yet.")
            return
        }
        
        rewardedAd.present(fromRootViewController: self) {
            // Call the rewardHandler with the reward item
            rewardHandler(rewardedAd.adReward)
        }
    }
}
