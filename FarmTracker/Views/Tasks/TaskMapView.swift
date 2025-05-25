import SwiftUI
import MapKit

struct TaskMapView: View {
    var tasks: [Task]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -31.95, longitude: 115.86),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: tasksWithLocation) { task in
            MapAnnotation(coordinate: task.coordinate!) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(task.isCompleted ? .gray : .red)
                    Text(task.title)
                        .font(.caption2)
                        .padding(2)
                        .background(Color.white)
                        .cornerRadius(4)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Task Map")
    }

    var tasksWithLocation: [Task] {
        tasks.filter { $0.coordinate != nil }
    }
}
