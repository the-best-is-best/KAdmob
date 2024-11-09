// swift-tools-version: 5.3
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
        // Google Mobile Ads SDK dependency
        .package(url: "https://github.com/googleads/googleads-mobile-ios-sdk.git", from: "11.10.0"),
        // Google User Messaging Platform SDK dependency
        .package(url: "https://github.com/google/GoogleUserMessagingPlatform.git", from: "2.6.0")
    ],
    targets: [
        .target(
            name: "KAdmob",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "googleads-mobile-ios-sdk"),
                .product(name: "GoogleUserMessagingPlatform", package: "GoogleUserMessagingPlatform")
            ],
            path: "KAdmob/Classes", // This matches the source files path in the podspec
            resources: [
                // If you have any resources like images, you can add them here
                // .process("KAdmob/Assets")
            ]
        ),
        .testTarget(
            name: "KAdmobTests",
            dependencies: ["KAdmob"]
        ),
    ]
)
