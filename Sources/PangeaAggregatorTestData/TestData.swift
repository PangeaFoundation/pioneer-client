import Foundation
import PangeaAggregator

public enum TestData {
    public static let address = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
    
    public static var singleMinuteCandle: Candle {
        candlesByMinute.randomElement()!
    }
    
    public static var candlesMinuteData: Data {
        load("candlesByMinute.json")
    }
    
    public static var candlesByMinute: [Candle] {
        decode(candlesMinuteData)
    }
    
    public static var candlesHourData: Data {
        load("candlesByHour.json")
    }
    
    public static var candlesByHour: [Candle] {
        decode(candlesHourData)
    }
    
    public static var candlesDayData: Data {
        load("candlesByDay.json")
    }
    
    public static var candlesByDay: [Candle] {
        decode(candlesDayData)
    }
    
    public static var singleToken: Token {
        tokens.randomElement()!
    }
    
    public static var tokensData: Data {
        return load("tokens.json")
    }
    
    public static var tokens: [Token] {
        return decode(tokensData)
    }
    
    public static var priceUpdates: [PriceUpdate] {
        decode(load("priceUpdates.json"))
    }
    
    public static var windowsData: [WindowsData] {
        decode(load("windowsData.json"))
    }
    
    private static func load(_ filename: String) -> Data {
        guard let file = Bundle.module.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in the bundle.")
        }
        
        do {
            return try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from bundle:\n\(error)")
        }
    }
    
    private static func decode<T: Decodable>(_ data: Data) -> T {
        do {
            return try PangeaAggregatorDecoder.decode(data)
        } catch {
            fatalError("Couldn't parse data as \(T.self):\n\(error)")
        }
    }
}
