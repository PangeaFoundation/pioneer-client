import Foundation
import PangeaAggregatorTestData
@testable import PangeaAggregator

final class TestDownloader: HTTPDataDownloader {
    
    func webSocketTask(with request: URLRequest) -> URLSessionWebSocketTask {
        URLSession.shared.webSocketTask(with: request)
    }
    
    func httpData(for request: URLRequest) async -> Result<Data, PangeaAggregatorError> {
        if request.url!.absoluteString.contains("Minute") {
            return .success(TestData.candlesMinuteData)
        } else if request.url!.absoluteString.contains("Hour") {
                return .success(TestData.candlesHourData)
        } else if request.url!.absoluteString.contains("Day") {
                return .success(TestData.candlesDayData)
        } else {
            return .success(TestData.tokensData)
        }
    }
}
