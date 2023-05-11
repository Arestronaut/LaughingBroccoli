//
// Copied from Tuist template 'blueprint-architecture-app-template'.
//

import Foundation
import ProjectDescription

extension Collection where Element == Scheme {

    /// Generates an array of `Scheme`s based on the configuration (-debug.xcconfig and -release.xcconfig)
    /// files found in the specified directory.
    ///
    /// - Parameters:
    ///    - path: The path to the configuration directory. Default is "./Configurations".
    ///    - namePrefix: The prefix to be used for naming the schemes.
    ///    - buildTargets: An array of `TargetReference`s representing the build targets for the schemes.
    ///    - testTargets: An array of `TestableTarget`s representing the test targets for the schemes.
    ///    - executableTarget: A `TargetReference` representing the executable target for the schemes.
    ///
    /// - Returns: An array of `Scheme`s generated based on the environment file. 
    public static func basedOnConfigurationDirectory(
        at path: String = "./Configurations",
        namePrefix: String,
        buildTargets: [TargetReference],
        testTargets: [TestableTarget],
        executableTarget: TargetReference) -> [Scheme]
    {
        do {
            return try Configuration.environments(basedOnConfigurationDirectoryAt: path)
                .reduce(into: [], { schemes, environment in
                    schemes.append(
                        Scheme.makeScheme(
                            for: environment,
                            namePrefix: namePrefix,
                            buildTargets: buildTargets,
                            testTargets: testTargets,
                            executableTarget: executableTarget
                        )
                    )
                })
        } catch {
            print("Schemes based on the environment file could not be generated: \(error)")
        }

        return []
    }
}

extension Scheme {

    static func makeScheme(
        for environment: String,
        namePrefix: String,
        buildTargets: [TargetReference],
        testTargets: [TestableTarget],
        executableTarget: TargetReference
    ) -> Scheme {
        Scheme(
            name: Scheme.generateName(withPrefix: namePrefix, for: environment),
            shared: true,
            hidden: false,
            buildAction: .buildAction(targets: buildTargets),
            testAction: .targets(testTargets, configuration: .configuration(.debug, for: environment)),
            runAction: .runAction(configuration: .configuration(.debug, for: environment), executable: executableTarget),
            archiveAction: .archiveAction(configuration: .configuration(.release, for: environment)),
            profileAction: .profileAction(configuration: .configuration(.release, for: environment)),
            analyzeAction: .analyzeAction(configuration: .configuration(.debug, for: environment))
        )
    }

    private static func generateName(withPrefix prefix: String, for environment: String) -> String {
        if environment == "default" {
            return prefix
        } else {
            return "\(prefix) \(environment.uppercased())"
        }
    }
}
