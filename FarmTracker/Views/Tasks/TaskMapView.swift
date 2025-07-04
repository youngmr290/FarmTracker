import SwiftUI
import MapKit
import CoreData

struct TaskMapView: View {
    @FetchRequest(
        sortDescriptors: []
    ) private var tasks: FetchedResults<TaskEntry>

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -31.95, longitude: 115.86),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: tasksWithLocation) { task in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: task.latitude, longitude: task.longitude)) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(task.isCompleted ? .gray : .red)
                    Text(task.title ?? "")
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

    var tasksWithLocation: [TaskEntry] {
        tasks.filter { task in
            task.latitude != 0 || task.longitude != 0
        }
    }
}
