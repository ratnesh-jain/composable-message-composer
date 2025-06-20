// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var tca: Self {
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    }
}

let package = Package(
    name: "composable-message-composer",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "MailComposerFeature",
            targets: ["MailComposerFeature"]),
        .library(
            name: "MessageComposerFeature",
            targets: ["MessageComposerFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "MailComposerFeature",
            dependencies: [.tca]
        ),
        .target(
            name: "MessageComposerFeature",
            dependencies: [.tca]
        ),
    ]
)
