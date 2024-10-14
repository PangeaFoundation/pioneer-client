import Foundation

public typealias WebSocketDataStream<T> = AsyncStream<Result<[T], PangeaAggregatorError>>

public protocol PangeaAggregatorClientProtocol: Actor {
    var priceWebSocketStream: WebSocketDataStream<PriceUpdate>? { get }
    var windowsDataWebSocketStream: WebSocketDataStream<WindowsData>? { get }
    func openWebSocket() async throws
    func getTokens() async -> Result<[Token], PangeaAggregatorError>
    func getCandles(address: String, start: Date, end: Date, interval: Candle.TimeInterval) async -> Result<[Candle], PangeaAggregatorError>
}
