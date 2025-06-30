import Foundation
import CoreData        // <- for NSManagedObject subclasses

extension FeedPaddock {
    /// kg delivered per feeding event
    var totalFeedKgPerFeeding: Double {
        Double(numberOfAnimals) *
        feedTargetGramsPerHdPerDay *
        Double(feedingFrequencyDays) / 1_000.0
    }
}
