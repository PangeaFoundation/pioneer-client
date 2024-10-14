import Foundation

public enum PangeaAggregatorDecoder {
    private static let decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .secondsSince1970
        return aDecoder
    }()
    
    public static func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
