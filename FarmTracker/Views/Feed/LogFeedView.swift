import SwiftUI
import CoreData                // ← for NSManagedObjectContext

struct LogFeedView: View {
    // ▸ Core-Data paddocks (fetched in here rather than passed in)
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FeedPaddock.name, ascending: true)],
        predicate: NSPredicate(format: "farmId == %@", "local-farm")
    )
    private var paddocks: FetchedResults<FeedPaddock>

    //core data context
    @Environment(\.managedObjectContext) private var ctx
    @Environment(\.presentationMode) private var presentationMode
    
    var feedTypes: [String]

    

    @State private var selectedPaddock: FeedPaddock?
    @State private var selectedFeedType = ""
    @State private var customAmount = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                // ── paddock picker
                Section(header: Text("Paddock")) {
                    Picker("Select", selection: $selectedPaddock) {
                        ForEach(paddocks) { paddock in
                            Text(paddock.name ?? "Unnamed")
                                .tag(Optional(paddock))   // Optional<FeedPaddock>
                        }
                    }
                }

                // ── feeding details
                if let paddock = selectedPaddock {
                    Section(header: Text("Feeding")) {
                        Text("Livestock: \(paddock.livestockType ?? "—")")

                        Picker("Feed Type", selection: $selectedFeedType) {
                            ForEach(feedTypes, id: \.self, content: Text.init)
                        }

                        HStack {
                            Text("Amount (kg)")
                            Spacer()
                            TextField("", text: $customAmount)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                        }
                        .onAppear {
                            customAmount     = String(format: "%.1f", paddock.totalFeedKgPerFeeding)
                            selectedFeedType = paddock.feedType ?? ""
                        }

                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                }

                // ── save button
                Button("Save Log") {
                    guard
                        let paddock = selectedPaddock,
                        let amount  = Double(customAmount),
                        !selectedFeedType.isEmpty
                    else { return }

                    // ➜  insert Core-Data log
                    let log = FeedLogEntry(context: ctx)
                    log.id             = UUID()
                    log.paddockName    = paddock.name ?? ""
                    log.livestockType  = paddock.livestockType
                    log.feedType       = selectedFeedType
                    log.amountKg       = amount
                    log.date           = date
                    log.farmId         = "local-farm"
                    log.updatedAt      = Date()

                    do {
                        try ctx.save()
                        print("✅ Saved log entry.")
                    } catch {
                        print("❌ Failed to save context: \(error.localizedDescription)")
                    }

                    
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(selectedPaddock == nil || selectedFeedType.isEmpty)
            }
            .navigationTitle("Log Feeding")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
