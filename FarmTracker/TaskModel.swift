import Foundation
import CoreLocation

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var coordinate: CLLocationCoordinate2D?
    var category: String?

    init(title: String, isCompleted: Bool = false, dueDate: Date? = nil, coordinate: CLLocationCoordinate2D? = nil, category: String? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.coordinate = coordinate
        self.category = category
    }
}
