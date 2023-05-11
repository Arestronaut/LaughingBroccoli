import Foundation

/// A cache validator to sample a caching logic.
protocol CacheValidator: AnyObject {

    /// Checks whether the cache is still valid or not.
    var isValid: Bool { get }

    /// Informs that the cached value has just been updated now.
    func valueHasJustBeenUpdated()
}

final class CacheValidatorImpl: CacheValidator {

    /// The lifetime of the cache in seconds.
    private let lifetime: TimeInterval

    /// The last updated date of the cache.
    private var lastUpdated: Date?

    init(lifetime: TimeInterval) {
        self.lifetime = lifetime
    }

    var isValid: Bool {
        guard let lastUpdated else { return true }
        return lastUpdated.addingTimeInterval(lifetime) >= Date()
    }

    func valueHasJustBeenUpdated() {
        lastUpdated = Date()
    }
}
