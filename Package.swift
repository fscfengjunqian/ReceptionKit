// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ReceptionKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "ReceptionCore", targets: ["ReceptionCore"]),
        .library(name: "ReceptionFirestore", targets: ["ReceptionFirestore"]),
        .library(name: "ReceptionMocks", targets: ["ReceptionMocks"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.15.0")
    ],
    targets: [
        .target(
            name: "ReceptionCore",
            path: "Sources/ReceptionCore"
        ),
        .target(
            name: "ReceptionFirestore",
            dependencies: [
                "ReceptionCore",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ],
            path: "Sources/ReceptionFirestore"
        ),
        .target(
            name: "ReceptionMocks",
            dependencies: ["ReceptionCore"],
            path: "Sources/ReceptionMocks"
        ),
        .testTarget(
            name: "ReceptionCoreTests",
            dependencies: ["ReceptionCore", "ReceptionMocks"],
            path: "Tests/ReceptionCoreTests"
        ),
        .testTarget(
            name: "ReceptionMocksTests",
            dependencies: ["ReceptionMocks", "ReceptionCore"],
            path: "Tests/ReceptionMocksTests"
        )
    ]
)
