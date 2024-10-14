import Foundation

public actor PangeaAggregatorClient: NSObject, PangeaAggregatorClientProtocol {
    private let apiHost: String
    private let authToken: String
    private let downloader: any HTTPDataDownloader
    private var webSocketTask: URLSessionWebSocketTask?
    public private(set) var priceWebSocketStream: WebSocketDataStream<PriceUpdate>?
    public private(set) var windowsDataWebSocketStream: WebSocketDataStream<WindowsData>?
    private let tokenAddressWhitelist: [String]?
    
    public init(apiHost: String,
                authToken: String,
                tokenAddressWhitelist: [String]?) {
        self.init(apiHost: apiHost,
                  authToken: authToken,
                  tokenAddressWhitelist: tokenAddressWhitelist,
                  downloader: URLSession.shared)
    }
    
    init(apiHost: String,
         authToken: String,
         tokenAddressWhitelist: [String]?,
         downloader: any HTTPDataDownloader) {
        self.apiHost = apiHost
        self.authToken = authToken
        self.tokenAddressWhitelist = tokenAddressWhitelist?.map { $0.lowercased() }
        self.downloader = downloader
    }
    
    deinit {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    public func openWebSocket() async throws {
        if webSocketTask != nil {
            return
        }
        
        let task = try createWebSocketTask()
        self.webSocketTask = task
        
        try await startWebSocket(task, .all)
        
        priceWebSocketStream = streamFromWebSocket(task)
        windowsDataWebSocketStream = streamFromWebSocket(task)
    }
    
    public func getTokens() async -> Result<[Token], PangeaAggregatorError> {
        return (await getData(endpoint: .allTokens))
            .map(filterTokens)
    }
    
    public func getCandles(address: String, start: Date, end: Date, interval: Candle.TimeInterval) async -> Result<[Candle], PangeaAggregatorError> {
        await getData(endpoint: .candles(address: address, start: start, end: end, interval: interval))
            .map { candles in filterDates(candles: candles, start: start, end: end) }
    }
    
    private func getData<T: Decodable>(endpoint: PangeaAggregatorEndpoint) async -> Result<[T], PangeaAggregatorError> {
        let url = endpoint.url(apiHost: apiHost)
        guard let request = getRequest(urlString: url) else {
            return .failure(.invalidUrl(url))
        }
        return (await downloader.httpData(for: request))
            .map { data in
                let dataString = String(data: data, encoding: .utf8) ?? ""
                print("Just received: '\(dataString)'")
                return data
            }
            .flatMap { data -> Result<[T], PangeaAggregatorError> in
                let items: [T]
                do {
                    items = try PangeaAggregatorDecoder.decode(data)
                } catch {
                    print(error)
                    return .failure(.decodingError(error))
                }
                return .success(items)
            }
    }
    
    private func filterDates(candles: [Candle], start: Date, end: Date) -> [Candle] {
        candles
            .filter { $0.startTime > start }
            .filter { $0.startTime < end }
    }
    
    private func getRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("Basic \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func filterTokens(_ tokens: [Token]) -> [Token] {
        guard let tokenAddressWhitelist else {
            return tokens
        }
        
        return tokens.filter { token in
            tokenAddressWhitelist.contains(token.address.lowercased())
        }
    }
    
    private func createWebSocketTask() throws -> URLSessionWebSocketTask {
        let url = PangeaAggregatorEndpoint.webSocket.url(apiHost: apiHost)
        guard let request = getRequest(urlString: url) else {
            throw PangeaAggregatorError.invalidUrl(url)
        }
        
        return downloader.webSocketTask(with: request)
    }
    
    private func startWebSocket(_ task: URLSessionWebSocketTask, _ subscriptionType: SubscriptionType) async throws {
        task.resume()
        
        let subscriptionMessage = WebSocketDataSubscriptionMessage(subscribe: [subscriptionType])
        let subscriptionData = try JSONEncoder().encode(subscriptionMessage)
        let subscriptionString = String(data: subscriptionData, encoding: .utf8) ?? ""
        try await task.send(.string(subscriptionString))
    }
    
    private func streamFromWebSocket<T: Codable & Sendable>(_ task: URLSessionWebSocketTask) -> WebSocketDataStream<T> {
        AsyncStream { continuation in
            Task {
                while task.closeCode == .invalid {
                    let message: URLSessionWebSocketTask.Message
                    do {
                        message = try await task.receive()
                    } catch {
                        print(error)
                        continuation.yield(.failure(.webSocketError(error)))
                        continuation.finish()
                        return
                    }
                    
                    if let items: [T] = decodeMessage(message) {
                        continuation.yield(.success(items))
                    }
                }
            }
        }
    }
    
    private func decodeMessage<T: Codable>(_ message: URLSessionWebSocketTask.Message) -> [T]? {
        let data: Data
        switch message {
        case .data(let messageData):
            data = messageData
        case .string(let string):
            let messageData = string.data(using: .utf8) ?? Data()
            data = messageData
        @unknown default:
            return nil
        }
        
        return try? JSONDecoder().decode([T].self, from: data)
    }
}
