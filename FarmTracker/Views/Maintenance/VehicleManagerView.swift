import SwiftUI
import CoreData

struct VehicleManagerView: View {
    @Environment(\.managedObjectContext) private var ctx
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.name, ascending: true)]
    ) private var vehicles: FetchedResults<Vehicle>

    @State private var showingAdd = false

    var body: some View {
        List {
            ForEach(vehicles) { v in
                NavigationLink(destination: VehicleDetailView(vehicle: v)) {
                    VStack(alignment: .leading) {
                        Text(v.name ?? "Unnamed").font(.headline)
                        if let parts = v.partNumbers, !parts.isEmpty {
                            Text("Parts: \(parts)").font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Vehicles")
        .toolbar {
            Button { showingAdd = true } label: { Image(systemName: "plus") }
        }
        .sheet(isPresented: $showingAdd) {
            NavigationView { AddVehicleView() }
        }
    }
}
