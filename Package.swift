// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CellSheetCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "CellSheetCore", targets: ["CellSheetCore"])],
    targets: [
        .target(name: "CellSheetCore", path: "Core"),
        .testTarget(name: "CellSheetCoreTests", dependencies: ["CellSheetCore"], path: "Tests")
    ]
)
