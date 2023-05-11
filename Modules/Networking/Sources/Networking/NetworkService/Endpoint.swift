/**
 An Endpoint of an api which is needed to send requests via `NetworkService`.

 This protocol can be used to define an endpoint without a response.

 Depending on the use case, the protocol should be extended by e.g. the http method or http headers.
 To be able to define responses or parameters a separate protocol should be created which is based on this protocol.
 See `EndpointWithResponse` for example.
 */
public protocol Endpoint: CustomStringConvertible {
    var url: String { get }
}

public extension Endpoint {
    var description: String { url }
}

/**
 An Endpoint of an api which is needed to send requests via `NetworkService` and get a response of type `Response`.
 The `Response` defines the DTO type which is expected from the endpoint.
 */
public protocol EndpointWithResponse: Endpoint {
    associatedtype Response: Decodable
}

public extension EndpointWithResponse {
    var description: String {
        "\(url) response-type: \(Response.self)"
    }
}
