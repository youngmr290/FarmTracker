import SwiftUI
import CoreData

struct MaintenanceListView: View {
    @Environment(\.managedObjectContext) private var ctx

    // Vehicle list for filter
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.name, ascending: true)]
    ) private var vehicles: FetchedResults<Vehicle>

    // All maintenance records
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MaintenanceRecord.serviceDate, ascending: false)]
    ) private var records: FetchedResults<MaintenanceRecord>

    // UI state
    @State private var selectedVehicleID: NSManagedObjectID? = nil
    @State private var showingAdd = false
    @State private var showingVehicleManager = false

    // Filtered array
    private var filteredRecords: [MaintenanceRecord] {
        if let id = selectedVehicleID {
            return records.filter { $0.vehicle?.objectID == id }
        } else {
            return Array(records)
        }
    }

    var body: some View {
        List {
            // ── Vehicle filter menu
            Section {
                Picker("Vehicle", selection: $selectedVehicleID) {
                    Text("All Vehicles").tag(nil as NSManagedObjectID?)
                    ForEach(vehicles, id: \.objectID) { v in
                        Text(v.name ?? "Unnamed")
                            .tag(v.objectID as NSManagedObjectID?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            // ── Maintenance records
            ForEach(filteredRecords) { r in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(r.vehicle?.name ?? "Unknown").font(.headline)
                        Spacer()
                        Text(r.serviceDate ?? Date(), style: .date).font(.subheadline)
                    }

                    Text(r.workDone ?? "—").font(.caption)

                    if r.kmsOrHours > 0 {
                        Text("Km / Hrs: \(r.kmsOrHours)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    if let note = r.notes, !note.isEmpty {
                        Text(note)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Maintenance")
        // SINGLE toolbar with both buttons
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingVehicleManager = true
                } label: {
                    Label("Manage Vehicles", systemImage: "wrench.and.screwdriver")
                }

                Button {
                    showingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            NavigationView { AddMaintenanceView() }
        }
        .sheet(isPresented: $showingVehicleManager) {
            NavigationView { VehicleManagerView() }
        }
    }
}
