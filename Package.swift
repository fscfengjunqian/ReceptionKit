// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ReceptionKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
    ],
    products: [
        .library(name: "ReceptionCore", targets: ["ReceptionCore"]),
        .library(name: "ReceptionFirestore", targets: ["ReceptionFirestore"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.15.0")
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
                .product(
                    name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ],
            path: "Sources/ReceptionFirestore"
        ),
        .target(
            name: "ReceptionMocks",
            dependencies: ["ReceptionCore"],
            path: "Tests/ReceptionMocks"
        ),
        .testTarget(
            name: "ReceptionCoreTests",
            dependencies: ["ReceptionCore", "ReceptionMocks"],
            path: "Tests/ReceptionCoreTests"
        ),
        .testTarget(
            name: "ReceptionFirestoreTests",
            dependencies: [
                "ReceptionFirestore",
                "ReceptionMocks",
                .product(
                    name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ],
            path: "Tests/ReceptionFirestoreTests"
        )
    ]
)
