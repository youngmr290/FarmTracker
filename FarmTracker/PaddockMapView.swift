import SwiftUI
import MapKit

struct PaddockMapView: View {
    var paddocks: [Paddock]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -31.95, longitude: 115.86),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: paddocks) { paddock in
            MapAnnotation(coordinate: paddock.location) {
                VStack {
                    Text(paddock.name)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(6)
                    Image(systemName: "scope")
                }
            }
        }
    }
}
