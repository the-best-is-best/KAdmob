import GoogleMobileAds
import UIKit

// Enum to define banner ad types
 enum KAdmobBannerType {
    case banner
    case fullBanner
    case largeBanner
}

@objc public class KBannerAdView: UIView {

    private var bannerView: GAMBannerView!

    // Enum to define banner ad types
    @objc public enum KAdmobBannerType: Int {
        case banner
        case fullBanner
        case largeBanner
    }

    // Property to hold the ad unit ID, default is nil
    @objc public var adUnitID: String? // Default is nil

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        // Throw an exception if adUnitID is nil
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

        // Set the ad unit ID and load an ad
        bannerView.adUnitID = adUnitID // Use the variable instead of a hardcoded string
        bannerView.load(GADRequest())
    }
}
