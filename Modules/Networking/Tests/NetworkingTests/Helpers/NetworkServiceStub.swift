import XCTest
@testable import Networking

class NetworkServiceStub: NetworkService {
    private var data: Data?
    private var error: Error?

    init(data: Data? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }

    convenience init(json: String) {
        self.init(data: json.data(using: .utf8))
    }

    func sendRequest<E: Endpoint>(for endpoint: E) async throws {
        if let error = error {
            throw error
        }
    }

    func sendRequest<E: EndpointWithResponse>(for endpoint: E) async throws -> E.Response {
        if let error = error {
            throw error
        }

        if let data = data {
            return try JSONDecoder().decode(E.Response.self, from: data)
        }

        preconditionFailure("Either data or error must be set.")
    }
}
