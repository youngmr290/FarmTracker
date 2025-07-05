import SwiftUI
import CoreData

struct AddMaintenanceView: View {
    @Environment(\.presentationMode) private var dismiss
    @Environment(\.managedObjectContext) private var ctx

    // fetch vehicles for picker
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Vehicle.name, ascending: true)]
    ) private var vehicles: FetchedResults<Vehicle>

    @State private var selectedVehicleID: NSManagedObjectID? = nil
    @State private var newVehicleName = ""

    @State private var serviceDate = Date()
    @State private var kmsOrHoursText = ""
    @State private var workDone = ""
    @State private var notes = ""

    var body: some View {
        Form {
            // vehicle picker
            Section(header: Text("Vehicle")) {
                Picker("Select", selection: $selectedVehicleID) {
                    Text("Choose…").tag(nil as NSManagedObjectID?)
                    ForEach(vehicles, id: \.objectID) { v in
                        Text(v.name ?? "Unnamed").tag(v.objectID as NSManagedObjectID?)
                    }
                }
                TextField("Or new vehicle", text: $newVehicleName)
            }

            DatePicker("Service Date", selection: $serviceDate, displayedComponents: .date)
            
            HStack {
                Text("KMs / Hours")
                Spacer()
                TextField("0", text: $kmsOrHoursText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: kmsOrHoursText) { newValue in
                        // Strip any non-digits to enforce numeric input
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            kmsOrHoursText = filtered
                        }
                    }
            }
            
            
            TextField("Work Done", text: $workDone)
            ZStack(alignment: .topLeading) {
                if notes.isEmpty {
                    Text("Enter notes...")
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                }

                TextEditor(text: $notes)
                    .frame(height: 100)
                    .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
            }

        }
        .navigationTitle("New Service")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(workDone.isEmpty || (selectedVehicleID == nil && newVehicleName.isEmpty))
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss.wrappedValue.dismiss() }
            }
        }
    }

    private func save() {
        // resolve or create vehicle
        let vehicle: Vehicle
        if !newVehicleName.isEmpty {
            vehicle = Vehicle(context: ctx)
            vehicle.id = UUID()
            vehicle.name = newVehicleName
        } else if let id = selectedVehicleID,
                  let v = vehicles.first(where: { $0.objectID == id }) {
            vehicle = v
        } else { return }

        let rec = MaintenanceRecord(context: ctx)
        rec.id = UUID()
        rec.serviceDate = serviceDate
        rec.kmsOrHours  = Int32(kmsOrHoursText) ?? 0
        rec.workDone = workDone
        rec.notes = notes.isEmpty ? nil : notes
        rec.vehicle = vehicle

        try? ctx.save()
        dismiss.wrappedValue.dismiss()
    }
}
