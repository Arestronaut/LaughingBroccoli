import Foundation
import os.log

public extension Logger {

    static var subsystem: String = Bundle.main.bundleIdentifier ?? ""

    init(category: String) {
        self.init(subsystem: Logger.subsystem, category: category)
    }
}
