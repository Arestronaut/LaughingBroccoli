/// Errors that can occur when sending requests.
public enum NetworkError: Error {

    /// An invalid URL is defined.
    case invalidUrl

    /// An unexpected URL response type was received.
    case unexpectedURLResponse

    /// The request has failed with a status code.
    case failed(statusCode: Int)

    /// An api request has returned with an error message.
    case responseError(_ message: String)

    /// No data was returned from an api.
    case noData
}
