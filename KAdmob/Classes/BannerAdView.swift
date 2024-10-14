import GoogleMobileAds
import SwiftUI

@objc public class KBannerView: UIView {
    private var bannerView: GADBannerView?
    
    @objc public var adUnitID: String? {
        didSet {
            if let adUnitID = adUnitID {
                setupBannerView(adUnitID: adUnitID)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBannerView(adUnitID: adUnitID ?? "")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBannerView(adUnitID: adUnitID ?? "")
    }
    
    private func setupBannerView(adUnitID: String) {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        if let bannerView = bannerView {
            bannerView.adUnitID = adUnitID
            
            // Set the root view controller for the banner view
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                bannerView.rootViewController = rootViewController
            }

            // Load the ad
            bannerView.load(GADRequest())
            
            // Add bannerView to the KBannerView
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(bannerView)
            
            // Set up constraints
            NSLayoutConstraint.activate([
                bannerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                bannerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    func makeUIView(context: Context) -> KBannerView {
        let bannerView = KBannerView()
        bannerView.adUnitID = adUnitID
        return bannerView
    }
    
    func updateUIView(_ uiView: KBannerView, context: Context) {
        // Update the UIView if needed
    }
}

