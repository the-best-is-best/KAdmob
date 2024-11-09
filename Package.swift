// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "KAdmob",
    platforms: [
        .iOS(.v13)  // Set the iOS deployment target to 13.0, as in the podspec
    ],
    products: [
        .library(
            name: "KAdmob",
            targets: ["KAdmob"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "11.10.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-user-messaging-platform", from: "2.6.0")
    ],
    targets: [
        .target(
            name: "KAdmob",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "GoogleUserMessagingPlatform", package: "swift-package-manager-google-user-messaging-platform")
            ],
            path: "KAdmob/Classes",
            resources: []
        ),
        .testTarget(
            name: "KAdmobTests",
            dependencies: ["KAdmob"]
        ),
    ]
)
