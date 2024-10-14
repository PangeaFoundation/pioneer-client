import Foundation

public struct PriceUpdate: Sendable {
    public let chain, provider: String
    public let timestamp, localTimestamp: Date
    public let blockNumber: Int
    public let transactionHash: String
    public let transactionIndex, logIndex, version: Int
    public let poolAddress: String
    public let amount0, amount1: Double
    public let token0Address: String
    public let token0Decimals: Int
    public let token0Name, token0Symbol, token1Address: String
    public let token1Decimals: Int
    public let token1Name, token1Symbol: String
    public let txPrice, t0TgtPrice, t1TgtPrice: Double
    public let priceStatus: Int
    public let blockHash: String
}

extension PriceUpdate: Codable {
    enum CodingKeys: String, CodingKey {
        case chain, provider, timestamp
        case localTimestamp = "local_timestamp"
        case blockNumber = "block_number"
        case transactionHash = "transaction_hash"
        case transactionIndex = "transaction_index"
        case logIndex = "log_index"
        case version
        case poolAddress = "pool_address"
        case amount0, amount1
        case token0Address = "token0_address"
        case token0Decimals = "token0_decimals"
        case token0Name = "token0_name"
        case token0Symbol = "token0_symbol"
        case token1Address = "token1_address"
        case token1Decimals = "token1_decimals"
        case token1Name = "token1_name"
        case token1Symbol = "token1_symbol"
        case txPrice = "tx_price"
        case t0TgtPrice = "t0_tgt_price"
        case t1TgtPrice = "t1_tgt_price"
        case priceStatus = "price_status"
        case blockHash = "block_hash"
    }
}
