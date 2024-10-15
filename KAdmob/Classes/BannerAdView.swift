import GoogleMobileAds
import UIKit

@objc public class KBannerAdView: UIView {

    private var bannerView: GAMBannerView!

    @objc public enum KAdmobBannerType: Int {
        case banner = 0
        case fullBanner = 1
        case largeBanner = 2
    }

    @objc public var adUnitID: String? // Property to hold the ad unit ID, default is nil

    // Initializer that takes adUnitID and adType
    @objc public init(adUnitID: String?) {
        super.init(frame: .zero)
        self.adUnitID = adUnitID
        setupBannerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBannerView()
    }

    // Function to set up the banner view
    private func setupBannerView() {
        bannerView = GAMBannerView(adSize: GADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bannerView)

        // Add constraints to position the banner view
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // Public method to load an ad of a specific type
    @objc public func loadAd(ofType type: KAdmobBannerType) {
        guard let adUnitID = adUnitID else {
            fatalError("Ad Unit ID cannot be nil. Please set a valid ad unit ID.")
        }

        let adSize: GADAdSize
        switch type {
        case .banner:
            adSize = GADAdSizeBanner
        case .fullBanner:
            adSize = GADAdSizeFullBanner
        case .largeBanner:
            adSize = GADAdSizeLargeBanner
        }

        // Update banner view size
        bannerView.adSize = adSize
        bannerView.adUnitID = adUnitID // Use the variable instead of a hardcoded string
        bannerView.load(GADRequest())
    }
}
