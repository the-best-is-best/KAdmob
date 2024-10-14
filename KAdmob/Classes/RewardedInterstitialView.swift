import GoogleMobileAds
import SwiftUI

@objc public class KRewardedInterstitialView: UIView {
    private var rewardedInterstitialAd: GAMRewardedInterstitialAd?

    @objc public var adUnitID: String? {
        didSet {
            if let adUnitID = adUnitID {
                loadRewardedInterstitialAd(adUnitID: adUnitID)
            }
        }
    }

    // Callback to return the reward item
    public var onRewarded: ((GADAdReward) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadRewardedInterstitialAd(adUnitID: adUnitID ?? "")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadRewardedInterstitialAd(adUnitID: adUnitID ?? "")
    }

    private func loadRewardedInterstitialAd(adUnitID: String) {
        GAMRewardedInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load rewarded interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.rewardedInterstitialAd = ad
            self?.rewardedInterstitialAd?.fullScreenContentDelegate = self
        }
    }

    @objc public func present(from viewController: UIViewController) {
        rewardedInterstitialAd?.present(fromRootViewController: viewController, userDidEarnRewardHandler: { [weak self] in
            guard let reward = self?.rewardedInterstitialAd?.adReward else {
                print("Reward not available")
                return
            }
            self?.onRewarded?(reward) // Call the callback with the reward item
        })
    }
}

// MARK: - GADFullScreenContentDelegate
extension KRewardedInterstitialView: GADFullScreenContentDelegate {
    public func adDidRecordImpression(_ ad: GADFullScreenContent) {
        print("Rewarded interstitial ad did record impression.")
    }

    public func adDidDismissFullScreenContent(_ ad: GADFullScreenContent) {
        print("Rewarded interstitial ad did dismiss.")
        // Optionally, load a new ad
        loadRewardedInterstitialAd(adUnitID: adUnitID ?? "")
    }

    public func ad(_ ad: GADFullScreenContent, didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded interstitial ad failed to present: \(error.localizedDescription)")
    }
}

struct RewardedInterstitialAdView: UIViewRepresentable {
    let adUnitID: String
    var onRewarded: ((GADAdReward) -> Void)?

    func makeUIView(context: Context) -> KRewardedInterstitialView {
        let rewardedInterstitialView = KRewardedInterstitialView()
        rewardedInterstitialView.adUnitID = adUnitID
        rewardedInterstitialView.onRewarded = onRewarded // Set the callback
        return rewardedInterstitialView
    }

    func updateUIView(_ uiView: KRewardedInterstitialView, context: Context) {
        // Update the UIView if needed
    }
}

