import Foundation

public struct Token: Hashable, Sendable {
    public let symbol, name, address: String
    public let usdPrice: Double
    public let decimals: Int
    public let lastUpdate: Date
}

extension Token: Codable {
    enum CodingKeys: String, CodingKey {
        case symbol, name, address
        case usdPrice = "usd_price"
        case decimals
        case lastUpdate = "last_update"
    }
}

extension Token: Identifiable {
    public var id: String {
        address
    }
}

extension Token {
    public var iconURL: URL? {
        let spothqUrl = "https://github.com/spothq/cryptocurrency-icons/blob/master/128/icon"
        let erikThiartUrl = "https://github.com/ErikThiart/cryptocurrency-icons/blob/master/128"
        
        let url: String
        switch symbol {
        case "WETH":
            url = "\(spothqUrl)/eth.png"
        case "WBTC":
            url = "https://cryptologos.cc/logos/wrapped-bitcoin-wbtc-logo.png?v=034"
        case "PEPE":
            url = "\(erikThiartUrl)/pepe-coin.png"
        default:
            return nil
        }
        
        return URL(string: "\(url)?raw=true")
    }
}
