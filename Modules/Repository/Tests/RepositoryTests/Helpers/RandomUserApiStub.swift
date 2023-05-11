import Foundation
import Networking

class RandomUserApiStub: RandomUserApi {
    let user: RandomUserResultDTO?
    let error: Error?

    init(user: RandomUserResultDTO?, error: Error?) {
        self.user = user
        self.error = error
    }

    func fetchUser() async throws -> RandomUserResultDTO {
        if let error = error {
            throw error
        }

        if let user = user {
            return user
        }

        preconditionFailure("Either user or error must be set.")
    }
}
