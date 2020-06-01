// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MockingbirdUIKit",
    platforms: [
        .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(name: "MockingbirdUIKit", targets: ["MockingbirdUIKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/DeclarativeHub/Mockingbird.git", .branch("master"))
    ],
    targets: [
        .target(name: "MockingbirdUIKit", dependencies: ["Mockingbird"], path: "Sources")
    ]
)
