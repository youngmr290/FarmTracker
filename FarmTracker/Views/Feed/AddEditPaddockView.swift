import SwiftUI

struct AddEditPaddockView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var paddocks: [FeedPaddock]
    @Binding var livestockTypes: [String]
    @Binding var feedTypes: [String]

    @State private var name: String = ""
    @State private var selectedLivestock: String = "Ewes"
    @State private var selectedFeedType: String = "Hay"
    @State private var numberOfAnimals: Int = 100
    @State private var feedTarget: Double = 500
    @State private var frequencyDays: Int = 1

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Paddock Info")) {
                    TextField("Paddock Name", text: $name)

                    Picker("Livestock Type", selection: $selectedLivestock) {
                        ForEach(livestockTypes, id: \.self) { Text($0) }
                    }

                    Picker("Feed Type", selection: $selectedFeedType) {
                        ForEach(feedTypes, id: \.self) { Text($0) }
                    }
                }

                Section(header: Text("Feeding Info")) {
                    HStack {
                        Text("Number of Animals:")
                        Spacer()
                        TextField("", value: $numberOfAnimals, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                    }

                    HStack {
                        Text("Target Feed (g/hd/d):")
                        Spacer()
                        TextField("", value: $feedTarget, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                    }

                    Stepper(value: $frequencyDays, in: 1...14) {
                        Text("Frequency: Every \(frequencyDays) day(s)")
                    }
                }

                Button("Save") {
                    let paddock = FeedPaddock(
                        name: name,
                        livestockType: selectedLivestock,
                        numberOfAnimals: numberOfAnimals,
                        feedTargetGramsPerHdPerDay: feedTarget,
                        feedingFrequencyDays: frequencyDays,
                        feedType: selectedFeedType
                    )
                    paddocks.append(paddock)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Add Paddock")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
