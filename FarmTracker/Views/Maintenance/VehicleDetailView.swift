import SwiftUI

struct VehicleDetailView: View {
    @Environment(\.presentationMode) private var dismiss
    @Environment(\.managedObjectContext) private var ctx

    @ObservedObject var vehicle: Vehicle

    var body: some View {
        Form {
            Section(header: Text("Vehicle Name")) {
                TextField("Vehicle name", text: Binding(
                    get: { vehicle.name ?? "" },
                    set: { vehicle.name = $0 }
                ))
            }

            Section(header: Text("Notes")) {
                ZStack(alignment: .topLeading) {
                    if (vehicle.notes ?? "").isEmpty {
                        Text("Enter any special notes about this vehicle...")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.horizontal, 5)
                    }

                    TextEditor(text: Binding(
                        get: { vehicle.notes ?? "" },
                        set: { vehicle.notes = $0 }
                    ))
                    .frame(height: 120)
                }
            }
        }
        .navigationTitle("Edit Vehicle")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    try? ctx.save()
                    dismiss.wrappedValue.dismiss()
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss.wrappedValue.dismiss()
                }
            }
        }
    }
}
