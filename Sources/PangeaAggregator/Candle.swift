import Foundation

public struct Candle: Codable, Sendable {
    public enum TimeInterval: String, Codable, Sendable {
        case minute = "Minute"
        case hour = "Hour"
        case day = "Day"
    }
    
    public let interval: TimeInterval
    public let provider: String
    public let chain: Int
    public let startTime: Date
    public let name, symbol, address: String
    public let open, high, low, close: Double
    public let volume: Double

    enum CodingKeys: String, CodingKey {
        case interval, provider, chain
        case startTime = "start_time"
        case name, symbol, address
        case open, high, low, close, volume
    }
}

extension Candle {
    public var volumeDollars: Double {
        let price = (open + close) / 2.0
        return price * volume
    }
}

extension Candle: Identifiable {
    public var id: String {
        "\(self.address) \(self.startTime)"
    }
}

extension Candle: Comparable {
    public static func < (lhs: Candle, rhs: Candle) -> Bool {
        lhs.startTime < rhs.startTime
    }
}
