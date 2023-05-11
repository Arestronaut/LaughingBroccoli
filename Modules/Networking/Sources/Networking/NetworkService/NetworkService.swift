import Foundation

/// An abstraction of a network service to send data requests.
public protocol NetworkService {

    /**
     Sends a request for an preconfigured instance of an `Endpoint` without any response.

     - Throws: Some `Error` if the request could not be sent.
     - Parameter endpoint: The endpoint for which a request should be sent.
     */
    func sendRequest<E: Endpoint>(for endpoint: E) async throws

    /**
     Sends a request for an preconfigured instance of an `EndpointWithResponse` with a response of `Response`.

     - Parameter endpoint: The endpoint for which a request should be sent.
     - Throws: Some `Error` if the request could not be sent or the response could not be decoded to `E.Response`.
     - Returns: The response of the type defined in `E`.
     */
    func sendRequest<E: EndpointWithResponse>(for endpoint: E) async throws -> E.Response
}

/// The implementation of a network service which sends requests wie an instance of `URLSession`.
class NetworkServiceImpl: NetworkService {

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func sendRequest<E: Endpoint>(for endpoint: E) async throws {
        try await handleRequest(for: endpoint)
    }

    func sendRequest<E: EndpointWithResponse>(for endpoint: E) async throws -> E.Response {
        let data = try await handleRequest(for: endpoint)
        return try JSONDecoder().decode(E.Response.self, from: data)
    }
}

// MARK: - Private helper functions
private extension NetworkServiceImpl {

    /**
     Handles a request for an endpoint by creating a `URLRequest`, receiving `Data`, and validating the `URLResponse`.
     */
    @discardableResult
    private func handleRequest<E: Endpoint>(for endpoint: E) async throws -> Data {
        logger.debug("Start Request (\(endpoint))")

        do {
            let request = try endpoint.makeRequest()
            let (data, response) = try await urlSession.data(for: request)
            try validate(response)

            logger.debug("Request Finished (\(endpoint))")

            return data
        } catch {
            logger.error("Request Failed (\(endpoint)): \(error.localizedDescription)")
            throw error
        }
    }

    /**
     Validates if the HTTP response status code indicates a successfull request completion.

     - Parameters:
        - response: The received response metadata of an HTTP request.
        - allowedStatusCodes: The allowed HTTP status codes. Default is from 200 to 299.
     */
    private func validate(_ response: URLResponse, allowedStatusCodes: Range<Int> = 200..<300) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unexpectedURLResponse
        }

        guard allowedStatusCodes.contains(response.statusCode) else {
            throw NetworkError.failed(statusCode: response.statusCode)
        }
    }
}

// MARK: - Endpoint+MakeRequest
private extension Endpoint {

    /**
     Creates a `URLRequest` with the URL of the `Endpoint`.

     - Throws: `NetworkError.invalidUrl` if `url` is not valid.
     - Returns: A new `URLRequest` based on the `Endpoint`.
     */
    func makeRequest() throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl
        }

        return URLRequest(url: url)
    }
}
