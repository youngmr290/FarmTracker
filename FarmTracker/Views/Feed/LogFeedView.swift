import SwiftUI
import CoreData                // ← for NSManagedObjectContext

struct LogFeedView: View {
    // ▸ Core-Data paddocks (fetched in here rather than passed in)
    @Environment(\.managedObjectContext) private var ctx
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FeedPaddock.name, ascending: true)],
        predicate: NSPredicate(format: "farmId == %@", "local-farm")
    )
    private var paddocks: FetchedResults<FeedPaddock>

    // the logs are still plain in-memory for now
    @Binding var feedLogs: [FeedLogEntry]
    var feedTypes: [String]

    @Environment(\.presentationMode) private var presentationMode

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

                    // still append to in-memory array for now
                    let log = FeedLogEntry(
                        paddockName: paddock.name ?? "",
                        livestockType: paddock.livestockType ?? "",
                        feedType: selectedFeedType,
                        amountKg: amount,
                        date: date
                    )
                    feedLogs.append(log)
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
