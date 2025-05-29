import Foundation

struct FeedPaddock: Identifiable, Hashable, Equatable {
    let id: UUID
    var name: String
    var livestockType: String       
    var numberOfAnimals: Int
    var feedTargetGramsPerHdPerDay: Double
    var feedingFrequencyDays: Int
    var feedType: String

    init(
        id: UUID = UUID(),
        name: String,
        livestockType: String,
        numberOfAnimals: Int,
        feedTargetGramsPerHdPerDay: Double,
        feedingFrequencyDays: Int,
        feedType: String
    ) {
        self.id = id
        self.name = name
        self.livestockType = livestockType
        self.numberOfAnimals = numberOfAnimals
        self.feedTargetGramsPerHdPerDay = feedTargetGramsPerHdPerDay
        self.feedingFrequencyDays = feedingFrequencyDays
        self.feedType = feedType
    }

    var totalFeedKgPerFeeding: Double {
        (Double(numberOfAnimals) * feedTargetGramsPerHdPerDay * Double(feedingFrequencyDays)) / 1000.0
    }
}
