import Foundation
import CoreLocation

struct Paddock: Identifiable {
    var id = UUID()
    var name: String
    var location: CLLocationCoordinate2D
    var sheepCount: Int
    var tasks: [Task]
}
