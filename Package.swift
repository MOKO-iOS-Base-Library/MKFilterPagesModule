// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MKFilterPagesModule",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MKFilterPagesModule",
            targets: ["MKFilterPagesModule"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKBaseModuleLibrary.git", from: "2.2.19"),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKCustomUIModule.git", from: "2.1.17"),
    ],
    targets: [
        .target(
            name: "MKFilterPagesModule",
            dependencies: [
                "MKBaseModuleLibrary",
                "MKCustomUIModule",
            ],
            path: "MKFilterPagesModule",
            exclude: ["Classes/Vendor"],
            sources: ["Classes"],
            resources: [.process("Assets")],
            publicHeadersPath: "Classes",
            cSettings: [
                .headerSearchPath("Classes/FilterByAdvNamePage"),
                .headerSearchPath("Classes/FilterByAdvNamePage/Controller"),
                .headerSearchPath("Classes/FilterByAdvNamePage/Protocol"),
                .headerSearchPath("Classes/FilterByBeaconPage"),
                .headerSearchPath("Classes/FilterByBeaconPage/Controller"),
                .headerSearchPath("Classes/FilterByBeaconPage/Protocol"),
                .headerSearchPath("Classes/FilterByBXPButtonPage"),
                .headerSearchPath("Classes/FilterByBXPButtonPage/Controller"),
                .headerSearchPath("Classes/FilterByBXPButtonPage/Protocol"),
                .headerSearchPath("Classes/FilterByBXPSensorInfoPage"),
                .headerSearchPath("Classes/FilterByBXPSensorInfoPage/Controller"),
                .headerSearchPath("Classes/FilterByBXPSensorInfoPage/Protocol"),
                .headerSearchPath("Classes/FilterByBXPTagPage"),
                .headerSearchPath("Classes/FilterByBXPTagPage/Controller"),
                .headerSearchPath("Classes/FilterByBXPTagPage/Protocol"),
                .headerSearchPath("Classes/FilterByMacPage"),
                .headerSearchPath("Classes/FilterByMacPage/Controller"),
                .headerSearchPath("Classes/FilterByMacPage/Protocol"),
                .headerSearchPath("Classes/FilterByNanoBeaconPage"),
                .headerSearchPath("Classes/FilterByNanoBeaconPage/Controller"),
                .headerSearchPath("Classes/FilterByNanoBeaconPage/Protocol"),
                .headerSearchPath("Classes/FilterByNanoBeaconPage/View"),
                .headerSearchPath("Classes/FilterByOtherPage"),
                .headerSearchPath("Classes/FilterByOtherPage/Controller"),
                .headerSearchPath("Classes/FilterByOtherPage/Model"),
                .headerSearchPath("Classes/FilterByOtherPage/Protocol"),
                .headerSearchPath("Classes/FilterByPirPage"),
                .headerSearchPath("Classes/FilterByPirPage/Controller"),
                .headerSearchPath("Classes/FilterByPirPage/Protocol"),
                .headerSearchPath("Classes/FilterByTLMPage"),
                .headerSearchPath("Classes/FilterByTLMPage/Controller"),
                .headerSearchPath("Classes/FilterByTLMPage/Protocol"),
                .headerSearchPath("Classes/FilterByTofPage"),
                .headerSearchPath("Classes/FilterByTofPage/Controller"),
                .headerSearchPath("Classes/FilterByTofPage/Protocol"),
                .headerSearchPath("Classes/FilterByUIDPage"),
                .headerSearchPath("Classes/FilterByUIDPage/Controller"),
                .headerSearchPath("Classes/FilterByUIDPage/Protocol"),
                .headerSearchPath("Classes/FilterByURLPage"),
                .headerSearchPath("Classes/FilterByURLPage/Controller"),
                .headerSearchPath("Classes/FilterByURLPage/Protocol"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
            ]
        )
    ]
)
