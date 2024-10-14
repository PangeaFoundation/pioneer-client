import Foundation

public struct WindowsData: Sendable {
    public let provider, chain: String
    public let tokenName, tokenSymbol, tokenAddress: String
    public let windowType, startTime: Int
    public let open, high, low, close: Double
    public let volume: Double
    public let openTime, closeTime: Date
    public let count: Int
    public let sd, mean, accMeanCountWeight: Double
    public let status: Int
}

extension WindowsData {
    public var volumeDollars: Double {
        let price = (open + close) / 2.0
        return price * volume
    }
}

extension WindowsData: Codable {
    enum CodingKeys: String, CodingKey {
        case provider, chain
        case tokenName = "token_name"
        case tokenSymbol = "token_symbol"
        case tokenAddress = "token_address"
        case windowType = "window_type"
        case startTime = "start_time"
        case open, high, low, close, volume
        case openTime = "open_time"
        case closeTime = "close_time"
        case count, sd, mean
        case accMeanCountWeight = "acc_mean_count_weight"
        case status
    }
}

extension WindowsData: Identifiable {
    public var id: String {
        tokenAddress + "-" + openTime.ISO8601Format()
    }
}
