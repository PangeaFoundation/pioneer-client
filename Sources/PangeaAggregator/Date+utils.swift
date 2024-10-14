import Foundation

extension Date {
    var timestamp: Int {
        Int(timeIntervalSince1970)
    }
}
