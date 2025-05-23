import SwiftUI
import MapKit

struct DashboardView: View {
    @State private var showMap = true

    @State private var farm = Farm(
        name: "My Farm",
        paddocks: [
            Paddock(name: "North", location: CLLocationCoordinate2D(latitude: -31.95, longitude: 115.86), sheepCount: 100, tasks: []),
            Paddock(name: "South", location: CLLocationCoordinate2D(latitude: -31.96, longitude: 115.85), sheepCount: 150, tasks: [])
        ],
        isPremium: true
    )

    var body: some View {
        VStack {
            Picker("View Mode", selection: $showMap) {
                Text("Map").tag(true)
                Text("List").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if showMap {
                PaddockMapView(paddocks: farm.paddocks)
            } else {
                PaddockListView(paddocks: farm.paddocks)
            }
            
            NavigationLink(destination: AllTasksView(farm: farm)) {
                Text("All Tasks")
            }
            .padding(.bottom)

        }
        .navigationTitle(farm.name)
    }
}
