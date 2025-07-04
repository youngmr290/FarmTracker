

import SwiftUI
import CoreData

extension NumberFormatter {
    static var integer: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .none
        f.minimum = 0
        return f
    }
}

struct AddVaccinationView: View {
    @Environment(\.presentationMode) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var ctx

    @State private var date        = Date()
    @State private var animalClass = ""
    @State private var number  = 0
    @State private var numberText  = ""
    @State private var product     = ""
    @State private var batch       = ""
    @State private var photoData: Data? = nil
    @State private var showImagePicker = false          // <- new flag

    var body: some View {
        Form {
            // MARK: Basics
            DatePicker("Date", selection: $date, displayedComponents: .date)
            TextField("Animal Class (e.g. Lambs)", text: $animalClass)

            HStack {
                Text("Number of Stock")
                Spacer()
                TextField("0", text: $numberText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: numberText) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        number = Int(filtered) ?? 0
                        if filtered != newValue {
                            numberText = filtered
                        }
                    }
            }

            TextField("Product", text: $product)
            TextField("Batch Number", text: $batch)

            // MARK: Photo
            Button {
                showImagePicker = true
            } label: {
                HStack {
                    Image(systemName: "photo")
                    Text(photoData == nil ? "Add Photo" : "Change Photo")
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(imageData: $photoData)
            }

            if let data = photoData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("New Treatment")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(animalClass.isEmpty || product.isEmpty || numberText.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss.wrappedValue.dismiss() }
            }
        }
        .onAppear {
                    numberText = number > 0 ? String(number) : ""
                }
    }

    // MARK: -- Save helper
    private func save() {
        let vax = VaccinationRecord(context: ctx)
        vax.id            = UUID()
        vax.dateGiven     = date
        vax.animalClass   = animalClass
        vax.numberOfStock = Int32(number)
        vax.product       = product
        vax.batchNumber   = batch.isEmpty ? nil : batch
        vax.photo         = photoData
        try? ctx.save()
        presentationMode.wrappedValue.dismiss()
    }
}
