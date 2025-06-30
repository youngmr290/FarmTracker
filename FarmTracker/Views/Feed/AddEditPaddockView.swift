import SwiftUI
import CoreData

struct AddEditPaddockView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var ctx

    @Binding var livestockTypes: [String]
    @Binding var feedTypes: [String]
    
    // form state
    @State private var name: String = ""
    @State private var selectedLivestock: String = "Ewes"
    @State private var selectedFeedType: String = "Hay"
    @State private var numberOfAnimals: Int = 100
    @State private var feedTarget: Double = 500
    @State private var frequencyDays: Int = 1

    var body: some View {
        NavigationView {
            Form {
                // --- paddock info ---
                Section(header: Text("Paddock Info")) {
                    TextField("Paddock Name", text: $name)
                    
                    Picker("Livestock Type", selection: $selectedLivestock) {
                        ForEach(livestockTypes, id: \.self, content: Text.init)
                    }
                    
                    Picker("Feed Type", selection: $selectedFeedType) {
                        ForEach(feedTypes, id: \.self, content: Text.init)
                    }
                }
                
                // --- feeding info ---
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
                
                // --- save ---
                Button("Save") {
                    let p = FeedPaddock(context: ctx)
                    p.id = UUID()
                    p.name = name
                    p.livestockType = selectedLivestock
                    p.numberOfAnimals = Int32(numberOfAnimals)
                    p.feedTargetGramsPerHdPerDay = feedTarget
                    p.feedingFrequencyDays = Int32(frequencyDays)
                    p.feedType = selectedFeedType
                    p.farmId  = "local-farm"
                    p.updatedAt = Date()
                    
                    try? ctx.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Add Paddock")
            .navigationBarItems(trailing:
                Button("Cancel") { presentationMode.wrappedValue.dismiss() }
            )
        }
    }
}
