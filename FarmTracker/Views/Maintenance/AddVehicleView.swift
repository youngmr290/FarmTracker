import SwiftUI
import CoreData

struct AddVehicleView: View {
    @Environment(\.presentationMode) private var dismiss
    @Environment(\.managedObjectContext) private var ctx

    @State private var name = ""
    @State private var partNumbers = ""
    @State private var notes = ""

    var body: some View {
        Form {
            TextField("Vehicle Name", text: $name)
            Section(header: Text("Notes")) {
                ZStack(alignment: .topLeading) {
                    if notes.isEmpty {
                        Text("Enter any special notes about this vehicle...")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.horizontal, 5)
                    }

                    TextEditor(text: $notes)
                        .frame(height: 120)
                }
            }

        }
        .navigationTitle("New Vehicle")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }.disabled(name.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss.wrappedValue.dismiss() }
            }
        }
    }

    private func save() {
        let v = Vehicle(context: ctx)
        v.id = UUID()
        v.name = name
        v.partNumbers = partNumbers.isEmpty ? nil : partNumbers
        v.notes = notes.isEmpty ? nil : notes
        try? ctx.save()
        dismiss.wrappedValue.dismiss()
    }
}
