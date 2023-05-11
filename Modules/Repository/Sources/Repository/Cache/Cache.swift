import Foundation

/// A thread-safe Cache to hold and access a value.
final actor Cache<Value> {

    /// The value to be cached.
    private var value: Value?

    /// The cache validator to sample a caching logic where a value is only provided for a certain period of time.
    private let validator: CacheValidator

    init(validator: CacheValidator) {
        self.validator = validator
    }

    /// Read the cached value.
    ///
    /// If the output is nil, either no data has been cached yet or the cache has already expired.
    func read() -> Value? {
        validator.isValid ? value : nil
    }

    /// Updates the value to be cached.
    func update(with value: Value?) {
        self.value = value
        self.validator.valueHasJustBeenUpdated()

        logger.debug("Cache of \(type(of: value)) updated")
    }
}
