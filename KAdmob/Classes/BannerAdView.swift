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
        let viewWidth = UIScreen.main.bounds.width // Use the screen width for adaptive size
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        bannerView = GAMBannerView(adSize: adaptiveSize)
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

        // Update banner view size and load the ad
        bannerView.adSize = adSize
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.topViewController
        bannerView.load(GADRequest())
    }
}

extension UIApplication {
    // Method to get the top-most view controller in the app
    var topViewController: UIViewController? {
        guard let keyWindow = self.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).first else {
            return nil
        }
        return keyWindow.rootViewController?.topMostViewController()
    }
}

extension UIViewController {
    // Recursively find the top-most presented view controller
    func topMostViewController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? navigationController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? tabBarController
        }
        return self
    }
}
