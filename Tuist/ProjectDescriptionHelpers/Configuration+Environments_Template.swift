//
// Copied from Tuist template 'blueprint-architecture-app-template'.
//

import Foundation
import ProjectDescription

extension Collection where Element == Configuration {

    /// Generates an array of `Configuration`s based on the configuration (-debug.xcconfig and -release.xcconfig)
    /// files found in the specified directory.
    ///
    /// - Parameter path: The path to the directory containing the configuration files.
    ///
    /// - Returns: An array of `Configuration`s generated from the configuration directory.
    public static func basedOnConfigurationDirectory(at path: String = "./Configurations") -> [Configuration] {
        do {
            let configurations = try Configuration.environments(basedOnConfigurationDirectoryAt: path)
                .reduce(into: []) { result, environment in
                    result += Configuration.makeConfigurations(for: environment, xcconfigDirectoryPath: path)
                }

            return configurations
        } catch {
            print("Configurations based on the environment file could not be generated: \(error)")
        }

        return []
    }
}

extension Configuration {

    /// Retrieves a list of environments based on the configuration files found in the directory at the given path.
    ///
    /// - Parameter path: The path to the directory containing the configuration files.
    ///
    /// - Throws: An error if the directory at the given path cannot be accessed, or if its contents cannot be read.
    ///
    /// - Returns: An array of unique environments extracted from the filenames of the configuration files in the directory.
    public static func environments(basedOnConfigurationDirectoryAt path: String) throws -> [String] {
        let fileManager = FileManager.default
        let configurationDirectoryUrl = URL(filePath: path, directoryHint: .isDirectory)

        let configurationFiles = try fileManager.contentsOfDirectory(
            at: configurationDirectoryUrl,
            includingPropertiesForKeys: nil
        )

        let environments = configurationFiles
            .map { $0.lastPathComponent }
            .filter { $0.contains("-release.xcconfig") || $0.contains("-debug.xcconfig") }
            .compactMap { filename in
                let environment = String(filename.prefix(while: { $0 != "-" }))
                return environment.isEmpty ? nil : environment
            }

        return Array(Set(environments))
    }

    static func makeConfigurations(for environment: String, xcconfigDirectoryPath: String) -> [Configuration] {
        [
            .debug(
                name: .configuration(.debug, for: environment),
                xcconfig: "\(xcconfigDirectoryPath)/\(environment)-debug.xcconfig"
            ),
            .release(
                name: .configuration(.release, for: environment),
                xcconfig: "\(xcconfigDirectoryPath)/\(environment)-release.xcconfig"
            )
        ]
    }
}

extension ConfigurationName {

    public static func configuration(_ name: ConfigurationName, for environment: String) -> ConfigurationName {
        ConfigurationName(stringLiteral: "\(environment)-\(name.rawValue)")
    }
}
