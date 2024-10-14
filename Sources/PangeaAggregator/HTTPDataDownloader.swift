import Foundation

let validStatus = 200...299

protocol HTTPDataDownloader: Sendable {
    func webSocketTask(with: URLRequest) -> URLSessionWebSocketTask
    func httpData(for: URLRequest) async -> Result<Data, PangeaAggregatorError>
}

extension URLSession: HTTPDataDownloader {
    func httpData(for request: URLRequest) async -> Result<Data, PangeaAggregatorError> {
        do {
            guard let (data, response) = try await self.data(for: request,
                                                             delegate: nil) as? (Data, HTTPURLResponse) else {
                return .failure(.invalidServerResponse)
            }
            guard validStatus.contains(response.statusCode) else {
                return .failure(.invalidStatusCode(response.statusCode))
            }
            return .success(data)
        } catch {
            return .failure(.networkError(error))
        }
    }
}
