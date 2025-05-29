import Foundation

struct FeedLogEntry: Identifiable {
    let id = UUID()
    let paddockName: String
    let livestockType: String
    let feedType: String
    let amountKg: Double
    let date: Date
}
