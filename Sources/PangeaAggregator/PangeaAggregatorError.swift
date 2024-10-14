import Foundation

public enum PangeaAggregatorError: Error, Sendable {
    case decodingError(Error)
    case networkError(Error)
    case invalidStatusCode(Int)
    case invalidServerResponse
    case invalidUrl(String)
    case webSocketError(Error)
}
