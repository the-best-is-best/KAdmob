import GoogleMobileAds
import SwiftUI

@objc public class KRewardedAdView: UIView {
    private var rewardedAd: GAMRewardedAd?
    
    @objc public var adUnitID: String? {
        didSet {
            if let adUnitID = adUnitID {
                loadRewardedAd(adUnitID: adUnitID)
            }
        }
    }

    // Callback to return reward item
    public var onRewarded: ((GADAdReward) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadRewardedAd(adUnitID: adUnitID ?? "")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadRewardedAd(adUnitID: adUnitID ?? "")
    }

    private func loadRewardedAd(adUnitID: String) {
        GAMRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    @objc public func present(from viewController: UIViewController) {
        rewardedAd?.present(fromRootViewController: viewController, userDidEarnRewardHandler: { [weak self] in
            if let reward = self?.rewardedAd?.adReward {
                self?.onRewarded?(reward)
            }
        })
    }
}

// MARK: - GADFullScreenContentDelegate
extension KRewardedAdView: GADFullScreenContentDelegate {
    public func adDidRecordImpression(_ ad: GADFullScreenContent) {
        print("Rewarded ad did record impression.")
    }

    public func adDidDismissFullScreenContent(_ ad: GADFullScreenContent) {
        print("Rewarded ad did dismiss.")
        // Optionally, load a new ad
        loadRewardedAd(adUnitID: adUnitID ?? "")
    }

    public func ad(_ ad: GADFullScreenContent, didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present: \(error.localizedDescription)")
    }
}

struct RewardedAdView: UIViewRepresentable {
    let adUnitID: String
    var onRewarded: ((GADAdReward) -> Void)?

    func makeUIView(context: Context) -> KRewardedAdView {
        let rewardedAdView = KRewardedAdView()
        rewardedAdView.adUnitID = adUnitID
        rewardedAdView.onRewarded = onRewarded
        return rewardedAdView
    }

    func updateUIView(_ uiView: KRewardedAdView, context: Context) {
        // Update the UIView if needed
    }
}
