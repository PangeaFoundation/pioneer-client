import Foundation

enum PangeaAggregatorEndpoint {
    case allTokens
    case candles(address: String, start: Date, end: Date, interval: Candle.TimeInterval)
    case webSocket
}

extension PangeaAggregatorEndpoint {
    private static let tokensEndpoint = "/v1/api/markets/tokens"
    private static let webSocketEndpoint = "/v1/websocket"
    func url(apiHost: String) -> String {
        let webProtocol, endpoint: String
        switch self {
        case .webSocket:
            webProtocol = "wss"
        default:
            webProtocol = "https"
        }
        
        switch self {
        case .allTokens:
            endpoint = Self.tokensEndpoint
        case let .candles(address: address, start: start, end: end, interval: interval):
            endpoint = "\(Self.tokensEndpoint)/\(candleEndpoint(address: address, start: start, end: end, interval: interval))"
        case .webSocket:
            endpoint = Self.webSocketEndpoint
        }
        
        return "\(webProtocol)://\(apiHost)\(endpoint)"
    }
    
    private func candleEndpoint(address: String, start: Date, end: Date, interval: Candle.TimeInterval) -> String {
        "\(address)?start=\(start.timestamp)&end=\(end.timestamp)&interval=\(interval.rawValue)"
    }
}
