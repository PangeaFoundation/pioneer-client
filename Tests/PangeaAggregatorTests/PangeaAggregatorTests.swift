import Testing
@testable import PangeaAggregator

struct CodingTests {
    @Test func decodeToken() throws {
        let tokenString = """
                  {
                    "symbol": "",
                    "name": "",
                    "address": "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9",
                    "usd_price": 1.3164735416569968E-16,
                    "total_supply": 0.0,
                    "circulating_supply": 0.0,
                    "decimals": 0,
                    "nr_of_owners": 0,
                    "last_update": 1725887404,
                    "liquidity": 0.0
                  }
            """
        let tokenData = try #require(tokenString.data(using: .utf8))
        
        let token: Token = try PangeaAggregatorDecoder.decode(tokenData)
        #expect(token.address == "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9")
    }
    
    @Test func decodeCandle() throws {
        let candleString = """
            {
              "interval": "Hour",
              "provider": "UniSwpV2",
              "chain": 42,
              "start_time": 1724781600,
              "name": "Wrapped Ether",
              "symbol": "WETH",
              "address": "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
              "open": 2578.25261042948,
              "high": 2589.247479511606,
              "low": 2576.995167270198,
              "close": 2580.3887386574957,
              "volume": 113.56202668265462
            }
            """
        let candleData = try #require(candleString.data(using: .utf8))
        let candle: Candle = try PangeaAggregatorDecoder.decode(candleData)
        #expect(candle.address == "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2")
    }
}

struct ClientTests {
    @Test func getTokens() async throws {
        let testObject = PangeaAggregatorClient(apiHost: "pangea.foundation",
                                                authToken: "",
                                                tokenAddressWhitelist: nil,
                                                downloader: TestDownloader())
        let result = await testObject.getTokens()
        
        let tokens = try result.get()
        
        #expect(tokens.count == 7933)
    }
    
    @Test func getCandles() async throws {
        let testObject = PangeaAggregatorClient(apiHost: "pangea.foundation",
                                                authToken: "",
                                                tokenAddressWhitelist: nil,
                                                downloader: TestDownloader())
        let result = await testObject.getCandles(address: "", start: .distantPast, end: .distantFuture, interval: .hour)
        
        let candles = try result.get()
        
        #expect(candles.count == 51)
    }
}

