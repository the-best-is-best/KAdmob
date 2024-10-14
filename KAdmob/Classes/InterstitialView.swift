import GoogleMobileAds
import SwiftUI

@objc public class KInterstitialAdView: UIView {
    private var interstitialAd: GAMInterstitialAd?

    @objc public var adUnitID: String? {
        didSet {
            if let adUnitID = adUnitID {
                loadInterstitialAd(adUnitID: adUnitID)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadInterstitialAd(adUnitID: adUnitID ?? "")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadInterstitialAd(adUnitID: adUnitID ?? "")
    }

    private func loadInterstitialAd(adUnitID: String) {
        GAMInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
        }
    }

    @objc public func present(from viewController: UIViewController) {
        interstitialAd?.present(fromRootViewController: viewController)
    }
}

// MARK: - GADFullScreenContentDelegate
extension KInterstitialAdView: GADFullScreenContentDelegate {
    public func adDidRecordImpression(_ ad: GADFullScreenContent) {
        print("Interstitial ad did record impression.")
    }

    public func adDidDismissFullScreenContent(_ ad: GADFullScreenContent) {
        print("Interstitial ad did dismiss.")
        // Optionally, load a new ad
        loadInterstitialAd(adUnitID: adUnitID ?? "")
    }

    public func ad(_ ad: GADFullScreenContent, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial ad failed to present: \(error.localizedDescription)")
    }
}

struct InterstitialAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> KInterstitialAdView {
        let interstitialAdView = KInterstitialAdView()
        interstitialAdView.adUnitID = adUnitID
        return interstitialAdView
    }

    func updateUIView(_ uiView: KInterstitialAdView, context: Context) {
        // Update the UIView if needed
    }
}

