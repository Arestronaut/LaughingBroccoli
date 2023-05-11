import Foundation
@testable import Repository

class CacheValidatorStub: CacheValidator {
    
    var isValid: Bool

    init(isValid: Bool) {
        self.isValid = isValid
    }

    func valueHasJustBeenUpdated() { }
}
