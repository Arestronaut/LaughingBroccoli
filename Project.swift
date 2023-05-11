import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Extensions

let settings = SettingsDictionary()
    .currentProjectVersion("0")
    .bitcodeEnabled(false)
    .manualCodeSigning()

// MARK: - Project

let project = Project(
    name: "ExampleApp",
    organizationName: "de.adesso",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.1")),
        .local(path: "Modules/SharedUI"),
        .local(path: "Modules/Shared"),
        .local(path: "Modules/Networking"),
        .local(path: "Modules/Repository"),
        .local(path: "Modules/Domain"),
        // Add more packages or adesso libraries here
    ],
    settings: .settings(
        base: settings,
        configurations: .basedOnConfigurationDirectory(),
        defaultSettings: .recommended(
            excluding: [
                "MARKETING_VERSION",
                "CODE_SIGN_IDENTITY"
            ]
        )
    ),
    targets: [
        Target(
            name: "ExampleApp",
            platform: .iOS,
            product: .app,
            bundleId: "de.adesso.exampleapp",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
            infoPlist: "ExampleApp/Info.plist",
            sources: ["ExampleApp/Sources/**"],
            resources: ["ExampleApp/Resources/**"],
            dependencies: [
                .package(product: "Factory"),
                .package(product: "SharedUI"),
                .package(product: "Shared"),
                .package(product: "Repository"),
            ]
        ),
        Target(
            name: "ExampleAppTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "de.adesso.exampleappTests",
            deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
            infoPlist: "ExampleAppTests/Info.plist",
            sources: ["ExampleAppTests/Tests/**"],
            dependencies: [
                .target(name: "ExampleApp")
            ]
        )
    ],
    schemes: .basedOnConfigurationDirectory(
        namePrefix: "ExampleApp",
        buildTargets: ["ExampleApp"],
        testTargets: [
            "ExampleAppTests",
            "SharedUI",
            "Networking",
            "Repository",
        ],
        executableTarget: "ExampleApp"
    ),
    additionalFiles: [
        .glob(pattern: "Configurations/shared.xcconfig")
    ]
)
