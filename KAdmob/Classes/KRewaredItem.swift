import GoogleMobileAds
import UIKit

@objc public class KRewardAdItem: NSObject {
    @objc public var type: String
    @objc public var amount: Int
    
    @objc public init(_ type: String, _ amount: Int) {
        self.type = type
        self.amount = amount
    }
}
