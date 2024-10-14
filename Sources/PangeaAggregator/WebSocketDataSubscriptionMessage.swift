import Foundation

enum SubscriptionType: String, Codable {
    case all = "All"
    case windowsData = "WindowsData"
    case priceRawData = "PriceRawData"
    case orderBook = "OrderBook"
}

struct WebSocketDataSubscriptionMessage: Codable {
    let subscribe: [SubscriptionType]
}
