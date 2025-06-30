import SwiftUI
import CoreData

struct AddEditPaddockView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var ctx
    
    @Binding var livestockTypes: [String]
    @Binding var feedTypes: [String]
    
    // ── form state ──────────────────────────────────────────
    @State private var name: String = ""
    @State private var selectedLivestock: String = "Ewes"
    @State private var selectedFeedType: String = "Hay"
    
    // text versions so they update in real-time
    @State private var numberOfAnimalsText: String = "100"
    @State private var feedTargetText:     String = "500"
    
    @State private var frequencyDays: Int = 1
    
    // ── body ────────────────────────────────────────────────
    var body: some View {
        NavigationView {
            Form {
                // ── paddock info ───────────────────────────
                Section(header: Text("Paddock Info")) {
                    TextField("Paddock Name", text: $name)
                    
                    Picker("Livestock Type", selection: $selectedLivestock) {
                        ForEach(livestockTypes, id: \.self, content: Text.init)
                    }
                    
                    Picker("Feed Type", selection: $selectedFeedType) {
                        ForEach(feedTypes, id: \.self, content: Text.init)
                    }
                }
                
                // ── feeding info ───────────────────────────
                Section(header: Text("Feeding Info")) {
                    HStack {
                        Text("Number of Animals:")
                        Spacer()
                        TextField("", text: $numberOfAnimalsText)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Target Feed (g/hd/d):")
                        Spacer()
                        TextField("", text: $feedTargetText)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                    }
                    
                    Stepper(value: $frequencyDays, in: 1...14) {
                        Text("Frequency: Every \(frequencyDays) day(s)")
                    }
                }
                
                // ── save ───────────────────────────────────
                Button("Save") {
                    // dismiss keyboard (optional)
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                    
                    // convert strings → numbers
                    guard
                        let animals = Int(numberOfAnimalsText),
                        let target  = Double(feedTargetText)
                    else {
                        print("❌ Invalid numbers – not saving")
                        return
                    }
                    
                    print("🐑 animals:", animals, "target:", target)
                    
                    let p = FeedPaddock(context: ctx)
                    p.id = UUID()
                    p.name = name
                    p.livestockType = selectedLivestock
                    p.numberOfAnimals = Int32(animals)
                    p.feedTargetGramsPerHdPerDay = target
                    p.feedingFrequencyDays = Int32(frequencyDays)
                    p.feedType = selectedFeedType
                    p.farmId  = "local-farm"
                    p.updatedAt = Date()
                    
                    do { try ctx.save() }
                    catch { print("❌ save failed:", error.localizedDescription) }
                    
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
